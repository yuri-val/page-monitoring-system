require 'open-uri'
require 'open_uri_redirections'

class DataMonitor
	attr_reader :site, :only_fresh, :links, :logger

	def initialize(site, fresh)
		@site = site
		@only_fresh = fresh
		initialize_log
		set_article_links
		scan_links
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
			text = open(url, :allow_redirections => :all) { |f| page_string = f.read }
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
			art = article_save(link)
			write_version(art)
		end

		def article_save(link)
			v0 = Version.find_or_create_by(version: 0)
			art = Article.find_or_create_by(article_url: link)
			art.site = @site
			art.article_url = link
			art.status = Status.find_or_create_by(name: "Active")
			if art.current_version.nil?
				art.current_version = v0
			end
			art.save!
			art
		end

		def write_version(art)
			VersionManager.new(art)
		end

end
