namespace :monitoring do
  desc "Task scan only first pages for site"
  task fresh: :environment do
    Site.all.each do |site|
      DataMonitor.new(site, true)
    end
  end

  desc "Task scan all pages (pages_to_scan) for site"
  task all: :environment do
    Site.all.each do |site|
      DataMonitor.new(site, false)
    end
  end
end
