namespace :monitoring do
  desc "TODO"
  task fresh: :environment do
  end

  desc "TODO"
  task all: :environment do
  	DataMonitor.new(Site.first, false)
  end

end
