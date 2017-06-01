require 'open-uri'
require 'open_uri_redirections'

class VersionManager
  attr_reader :article, :ct, :logger

  def initialize(art)
    @article = art
    initialize_log
    set_version
    close_log
  end

  private
    #LOG
    def initialize_log
      @logger = ActiveSupport::Logger.new(Rails.root.join('log', 'version_manager.log').to_s)
      @logger.info "Task started at #{Time.now}"
    end

    def close_log
      @logger.info "Task finished at #{Time.now}"
    end

    def prepare_url(url)
      prot = ""
      dom = ""
      prot = @article.site.site_url.split('://').first + '://' unless url.start_with?('http')
      dom  = @article.site.site_url.split('/')[2] if  url.start_with?('/')
      prot + dom + url
    end

    def set_version
      v_data = {}
      url = URI(prepare_url(@article.article_url))
      @logger.info "Article to scan:  #{url}"
      text = ""
      status = ""
      begin
        open(url, :allow_redirections => :all) do |f|
          text = f.read
          status = f.status.first
        end
        unless status == "200"
          @article.deleted!
          @logger.info "Article was deleted"
          return
        end
        if @article.current_version.nil?
          save_version(text)
          @logger.info "First version saved"
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
        html_text = page.css(ct).last.to_html
      end
      unless @article.current_version.html_text == html_text
        save_version(text)
        @logger.info "Version was changed"
      end
    end

    def save_version(text)

      page = Nokogiri::HTML(text)
      doc = page.css(ct).last
      html_text = doc.to_html
      plain_text = doc.text

      ver = Version.new
      ver.article = @article
      ver.version = Time.now().strftime("%Y%m%d%H%M%S").to_i
      ver.html_text = html_text
      ver.plain_text = plain_text

      ver.save!

      @article.current_version = ver
      @article.save
      @logger.info "New version: #{ver.version}"

    end

end
