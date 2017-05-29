require 'open-uri'
			
class DataMonitor
	attr_reader :site, :only_fresh, :links

	def initialize(site, fresh)
		@site = site
		@only_fresh = fresh
		set_article_links	
	end

	private
		def set_article_links
			@links = if @only_fresh
									get_fresh_articles
								else
									get_all_articles
								end
		end

		def get_fresh_articles
			url = @site.site_url
			links = get_links_from_url(url)
		end

		def get_all_articles
			to = site.pages_to_parse
			links = []
			(1..to).each do |ind|
				url = site.paginator_url_tmpl.gsub('%_ind_%', ind)
				links += get_links_from_url(url)
			end
		end

		def get_links_from_url(url)
			open(url) do |f|
			  page_string = f.read
			end
			p page_string
		end



end