require 'colorize'

namespace :sites do
  desc "Adding new site to parse"
  task add: :environment do
    data = {}
    puts "1. Now the wizard will help you add a new site for versioning".green
    puts "Pls, enter site url (news page)".yellow
    puts " e.g.: 'http://4pda.ru/news/'".yellow
    print "> "

    data[:site_url] = STDIN.gets.strip
    if data[:site_url].empty?
      puts "Site url is empty. Continuation is not possible".red
      exit 0
    end

    puts "2. Ok, next. Enter news link template.".green
    puts "If you leave it empty, app will scan whole links on page".yellow
    puts "You can use regexp.".yellow
    puts ' e.g.: "4pda.ru\/\d*\/\d*\/\d*\/\d*\/"  (http://4pda.ru/2017/05/28/342727/)'.yellow
    print "> "
    data[:article_url_tmpl] = STDIN.gets.strip
    if data[:article_url_tmpl].empty?
      domain = data[:site_url].start_with?('http') ? data[:site_url].split('/')[2] : data[:site_url].split('/')[0]
      data[:article_url_tmpl] = domain
    end

    puts "3. Cool! Now tell me what app will be scan".green
    puts "I nean enter content (html) tag which contains data".yellow
    puts "If you leave it blank, the whole page will be scanned (body tag)".yellow
    puts "You can use css style".yellow
    puts ' e.g.: "div.content"  (<div class="content"> ... </div>)'.yellow
    print "> "
    data[:article_content_tag] = STDIN.gets.strip
    if data[:article_content_tag].empty?
      data[:article_content_tag] = 'body'
    end

    puts "4. Ok, what about pagination?".green
    puts "Enter the page pagination template".yellow
    puts "If you leave it empty, app will scan only #{data[:site_url]}".yellow
    puts ' e.g.: "http://4pda.ru/page/%_ind_%/"  (http://4pda.ru/page/2/)'.yellow
    print "> "
    data[:paginator_url_tmpl] = STDIN.gets.strip

    puts "5. Awsome! And last... Enter how many pages need to scan".green
    puts "Just a number. Default: 5".yellow
    puts ' e.g. "5"'
    print "> "
    data[:pages_to_scan] = STDIN.gets.strip
    if data[:pages_to_scan].empty?
      data[:pages_to_scan] = 5
    end

    puts data
    Site.create(data)
  end

  desc "Manage sites property"
  task manage: :environment do
    limit = 10
    offset = 0
    while true do
      sites = Site.limit(limit).offset(offset)
      if sites.any?
        puts "PAGE #{(offset / 10) + 1}"
        puts "#. Site url".green
        puts "------------------".green
        sites.each do |val|
          puts "#{val.id}. #{val.site_url}".green
        end
        puts "n - next page, q - exit, e{#} - edit, d{#} - delete"
      else
        puts "Nothing to show. Make your choise
              q - exit, e{#} - edit, d{#} - delete"
      end
      print "> "
      ans = STDIN.gets.strip.downcase
      case ans
      when 'n'
        limit += 10
        offset += 10
        next
      when 'q'
        exit 0
      when /e\d*/
        id = ans.delete("ed").to_i
        site = Site.find(id)
        raise "Can't find site with id #{id}" if site.nil?
        flds = %w(site_url article_url_tmpl article_content_tag paginator_url_tmpl pages_to_scan)
        flds.each do |fld|
          puts "#{fld.ljust(20)} = \"#{site[fld.to_sym]}\""
        end
        while true do
          puts "Enter field name you want to edit"
          print "> "
          fld_name = STDIN.gets.strip.downcase
          raise "Can't find field #{fld_name}" unless flds.include?(fld_name)
          puts "Enter new value"
          print "> "
          val = STDIN.gets.strip.downcase
          site[fld_name.to_sym] = val
          puts "n - next field, s - save, c - cancle"
          ans = STDIN.gets.strip.downcase
          case ans
          when 'n'
            next
          when 's'
            site.save!
            puts "Saving... #{site.inspect}"
            exit 0
          when 'c'
            puts 'Canceled'
            exit 0
          end
        end
      when /d\d*/
        id = ans.delete("ed").to_i
        site = Site.find(id)
        raise "Can't find site with id #{id}" if site.nil?
        puts "Do you realy want to delete #{site.inspect}?"
        puts "y - yes, n - no, c - cancle"
        print "> "
        ans = STDIN.gets.strip.downcase
        site.destroy if ans == 'y'
        exit 0
      end

    end
  end

  desc "Load site example to DB"
  task example: :environment do
    Site.create(site_url: 'http://4pda.ru/news/',
                article_url_tmpl: '4pda.ru\/\d*\/\d*\/\d*\/\d*\/',
                article_content_tag: 'div.content',
                paginator_url_tmpl: 'http://4pda.ru/page/%_ind_%/',
                pages_to_scan: 5)
    Site.create(site_url: 'http://brovary-rada.gov.ua/documents/',
                article_url_tmpl: '\/documents\/\d*\.html',
                article_content_tag: 'div.bg1-content.col-md-8.col-sm-8',
                paginator_url_tmpl: 'http://brovary-rada.gov.ua/documents/?start=%_ind_%0',
                pages_to_scan: 5)
  end

end
