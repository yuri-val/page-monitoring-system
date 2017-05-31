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

  desc "Show site property"
  task show: :environment do
    limit = 10
    offset = 0
    while true do
      puts "PAGE #{(offset % 10) + 1}"
      sites = Site.limit(limit).offset(offset)
      sites.each_with_index do |val, ind|
        puts "#{ind}. #{val.site_url}".green
      end
      puts "n - next page, q - exit, # - edit"
      ans = STDIN.gets.strip.downcase
      case ans
      when 'n'
        limit += 10
        offset += 10
        next
      when 'q'
        exit 0
      when /\d/
        puts 'editing...'
      end

    end
  end

  desc "TODO"
  task edit: :environment do
  end

  desc "TODO"
  task delete: :environment do
  end

  desc "Load site example to DB"
  task example: :environment do
    Site.create(site_url: 'http://4pda.ru/news/',
                article_url_tmpl: '4pda.ru\/\d*\/\d*\/\d*\/\d*\/',
                article_content_tag: 'div.content',
                paginator_url_tmpl: 'http://4pda.ru/page/%_ind_%/',
                pages_to_scan: 5)
  end

end
