require 'open-uri'

class VersionManager
  attr_reader :article, :ct

  def initialize(art)
    @article = art
    set_version
  end

  private
    def set_version
      v_data = {}
      url = URI(@article.article_url)
      text = ""
      status = ""
      open(url) do |f|
        text = f.read
        status = f.status.first
      end
      unless status = "200"
        @article.deleted!
        return
      end
      if @article.current_version.nil?
        save_version(text)
      else
        compare_and_save_version(text)
      end
    end

    def compare_and_save_version(text)
      @ct = @article.site.article_content_tag
      if ct.empty?
        html_text = text
      else
        page = Nokogiri::HTML(text)
        html_text = page.css(ct).last
      end
      unless @article.current_version.html_text == html_text
        save_version(text)
      end
    end

    def save_version(text)

      page = Nokogiri::HTML(text)
      html_text = page.css(ct).last
      plain_text = Nokogiri::HTML(html_text).search(ct).xpath('text()')

      version = Version.new
      version.article = @article
      version.html_text = html_text
      version.plain_text = plain_text
      version.version = Time.now().strftime("%Y%m%d%H%M%S")

      if version.save?
        @article.current_version = version
        @article.save
      end

    end

end
