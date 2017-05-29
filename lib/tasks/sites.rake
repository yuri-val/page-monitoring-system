namespace :sites do
  desc "Adding new site to parse"
  task add: :environment do
    data = {}
    puts "Now the wizard will help you add a new site for versioning"
    puts "Pls, enter site url (news page)"
    puts " e.g.: 'http://4pda.ru/news/'"

    data[:site_url] = STDIN.gets.strip
    if data[:site_url].empty?
      puts "Site url is empty. Continuation is not possible"
      exit 0
    end

    puts "Ok, next. Enter news link template."
    puts "If you leave it empty, app will scan whole links on page"
    puts "You can use regexp."
    puts " e.g.: '4pda.ru\/\d*\/\d*\/\d*\/\d*\/'"
    data[:article_url_tmpl] = STDIN.gets.strip

  end

  desc "TODO"
  task show: :environment do
  end

  desc "TODO"
  task edit: :environment do
  end

  desc "TODO"
  task delete: :environment do
  end

end
