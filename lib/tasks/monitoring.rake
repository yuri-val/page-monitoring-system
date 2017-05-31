namespace :monitoring do
  desc "TODO"
  task fresh: :environment do
    Site.each do |site|
      DataMonitor.new(site, true)
    end
  end

  desc "TODO"
  task all: :environment do
    Site.all.each do |site|
      DataMonitor.new(site, false)
    end
  end

end
