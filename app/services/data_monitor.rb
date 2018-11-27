require 'http'
require 'openssl'
require 'nokogiri'

class DataMonitor
  attr_reader :site, :only_fresh, :links, :logger

  def initialize(site, fresh)
    @site = site
    @only_fresh = fresh
    initialize_ctx
    initialize_log
    set_article_links
    scan_links
    close_log
  end

  private

  def initialize_ctx
    @ctx = OpenSSL::SSL::SSLContext.new
    @ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  # LOG
  def initialize_log
    @logger = ActiveSupport::Logger.new(Rails.root.join('log', 'data_monitor.log').to_s)
    @logger.info "Task started at #{Time.now}"
    @logger.info "Site to scan:  #{@site.site_url}"
    @logger.info "Only fresh: #{@only_fresh}"
  end

  def close_log
    @logger.info "Task finished at #{Time.now}"
  end

  # Links
  def set_article_links
    @links = if @only_fresh
               get_fresh_articles
             else
               get_all_articles
             end
    @links ||= []
  end

  def get_fresh_articles
    url = @site.site_url
    get_links_from_url(url)
  end

  def get_all_articles
    to = @site.pages_to_scan
    links = []
    (1..to).each do |ind|
      url = @site.paginator_url_tmpl.gsub('%_ind_%', ind.to_s)
      links += get_links_from_url(url)
    end
    links
  end

  def get_links_from_url(url)
    @logger.info "Page: #{url}"
    # text = open(url, :allow_redirections => :all, &:read)
    text = HTTP.get(url, ssl_context: @ctx).to_s
    reg_exp = Regexp.new(@site.article_url_tmpl)
    links = text.scan(reg_exp).uniq
    @logger.info "Links: #{links}"
    links
  end

  def scan_links
    @logger.info 'SCANNING...'
    @links.each do |link|
      scan_link(link)
    end
  end

  def scan_link(link)
    @logger.info "Link: #{link}"
    art = article_save(link)
    write_version(art)
  end

  def article_save(link)
    art = Article.find_or_create_by(article_url: link)
    v0 = art.versions.find_or_initialize_by(version: 0)
    art.site = @site
    art.article_url = link
    art.title = get_link_title(link)
    art.status = Status.find_or_create_by(name: 'Active')
    art.current_version = v0 if art.current_version.nil?
    art.save!
    art
  end

  def write_version(art)
    VersionManager.new(art)
  end

  def get_link_title(link)
    text = HTTP.follow(strict: false).get(prepare_url(link)).to_s
    doc = Nokogiri.HTML(text)
    title = ''
    title = doc.css('title').text
    if title.blank?
      data = doc.xpath('//meta[@name="title"]').last
      title = (data.to_h || {})['content']
    end
    puts title
    title
  rescue StandardError
    ''
  end

  def prepare_url(url)
    prot = ''
    dom = ''
    prot = @site.site_url.split('://').first + '://' unless url.start_with?('http')
    dom = @site.site_url.split('/')[2] if url.start_with?('/')
    prot + dom + url
  end
end
