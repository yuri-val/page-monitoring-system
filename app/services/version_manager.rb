require 'http'
require 'openssl'

class VersionManager
  attr_reader :article, :ct, :logger

  def initialize(art)
    @article = art
    initialize_ctx
    initialize_log
    set_version
    close_log
  end

  private

  def initialize_ctx
    @ctx = OpenSSL::SSL::SSLContext.new
    @ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  # LOG
  def initialize_log
    @logger = ActiveSupport::Logger.new(Rails.root.join('log', 'version_manager.log').to_s)
    @logger.info "Task started at #{Time.now}"
  end

  def close_log
    @logger.info "Task finished at #{Time.now}"
  end

  def prepare_url(url)
    prot = ''
    dom = ''
    prot = @article.site.site_url.split('://').first + '://' unless url.start_with?('http')
    dom = @article.site.site_url.split('/')[2] if url.start_with?('/')
    prot + dom + url
  end

  def set_version
    v_data = {}
    url = URI(prepare_url(@article.article_url))
    @logger.info "Article to scan:  #{url}"
    begin
      responce = HTTP.follow(strict: false).get(url, ssl_context: @ctx)
      text = responce.to_s
      unless responce.status.ok?
        @article.deleted!
        @logger.info 'Article was deleted'
        return
      end
      if @article.current_version.nil?
        save_version(text)
        @logger.info 'First version saved'
      else
        compare_and_save_version(text)
      end
    rescue Exception => msg
      @logger.error msg
    end
  end

  def compare_and_save_version(text)
    @ct = @article.site.article_content_tag
    if ct.empty?
      html_text = text
    else
      page = Nokogiri::HTML(text)
      content = page.css(ct).last
      html_text = if content.nil?
                    page.to_html
                  else
                    content.to_html
                  end
    end
    unless @article.current_version.html_text == html_text
      save_version(text)
      @logger.info 'Version was changed'
    end
  end

  def save_version(text)
    page = Nokogiri::HTML(text)
    doc = page.css(ct).last
    if doc.nil?
      html_text = page.to_html
      plain_text = page.text
    else
      html_text = doc.to_html
      plain_text = doc.text
    end

    ver = Version.new
    ver.article = @article
    ver.version = Time.now.strftime('%Y%m%d%H%M%S').to_i
    ver.html_text = html_text
    ver.plain_text = plain_text

    ver.save!

    @article.current_version = ver
    @article.save
    @logger.info "New version: #{ver.version}"
  end
end
