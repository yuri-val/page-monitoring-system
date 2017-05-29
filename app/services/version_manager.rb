require 'open-uri'

class VersionManager
  attr_reader :articles

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

end
