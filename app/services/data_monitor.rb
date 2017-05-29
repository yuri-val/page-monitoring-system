require 'open-uri'

class DataMonitor
	attr_reader :site, :only_fresh, :links, :logger

	def initialize(site, fresh)
		@site = site
		@only_fresh = fresh
		initialize_log
		set_article_links
		close_log
	end

	private
		#LOG
		def initialize_log
			@logger = ActiveSupport::Logger.new(Rails.root.join('log', 'data_monitor.log').to_s)
			@logger.info "Task started at #{Time.now}"
			@logger.info "Site to scan:  #{@site.site_url}"
			@logger.info "Only fresh: #{@only_fresh}"
		end

		def close_log
			@logger.info "Task finished at #{Time.now}"
		end

		#Links
		def set_article_links
			@links = if @only_fresh
									get_fresh_articles
								else
									get_all_articles
								end
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
			text = open(url) { |f| page_string = f.read }
			reg_exp = Regexp.new(@site.article_url_tmpl)
			links = text.scan(reg_exp).uniq!
			@logger.info "Links: #{links}"
			links

		end

		def scan_links
			@logger.info "SCANNING..."
			@links.each do |link|
				scan_link(link)
			end
		end

		def scan_link(link)
			@logger.info "Link: #{link}"
			art = nil
			if article_save?(link, art)
				write_version(art)
			end
		end

		def article_save?(link, art)
			art = Article.find_or_create_by(article_url: link)
			art.site = @site
			art.article_url = link
			art.status = Status.find_or_create_by(name: "Active")
			art.save
		end

		def write_version
			
		end

end
