namespace :update do
  desc "scrapes the list from treasury dept."
  task properties: :environment do
    var = UpdateProperties.new
    var.run
  end

  desc "adds aerial_image and better formats the address"
  task assessment: :environment do
    var = UpdateAssessment.new
    var.run
  end

  desc "use zillow API to update database"
  task zillow: :environment do
    var = UpdateZillow.new
    var.run
  end

  desc "get amount owed from treasury"
  task tax_bill: :environment do
    var = UpdateTaxBill.new
    var.run
  end

end
