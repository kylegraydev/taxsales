namespace :update_database do
  desc "scrapes the list from treasury dept."
  task sdtreas: :environment do
    var = UpdateProperties.new
    var.run
  end

  desc "adds aerial_image and better formats the address"
  task pq: :environment do
    var = UpdateParcel.new
    var.run
  end

  desc "use zillow API to update database"
  task zillow: :environment do
    var = UpdateZillow.new
    var.run
  end

end
