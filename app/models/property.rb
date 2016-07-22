class Property < ActiveRecord::Base
  # include ActionView::Helpers::NumberHelper

  has_attached_file :aerial_image,
                    styles: { medium: "300x300>", thumb: "100x100>" }

  geocoded_by :address
  before_save :geocode, only: :add_lat_long

  def fix_address_and_add_aerial_view
    scraper = Scraper2.new
    scraper.scrape(self)
    self.save
  end

  def add_defaulted_amount
    scraper = Scraper3.new
    amt = scraper.scrape(self)
    self.defaulted_amount = amt
    self.save
  end

  def get_valuation
    address = self.address

    prop = Rubillow::HomeValuation.search_results({:address => address, :citystatezip => 'california'})

    self.zpid = prop.zpid #id needed for zillow searches
    self.zestimate = prop.price
    self.save
  end

  def add_lat_long
    self.save
  end

  def get_prop_details
    zpid = self.zpid
    details = Rubillow::PropertyDetails.updated_property_details({ :zpid => zpid })
    # pry
    # details.edited_facts[:use_code]
    # details.edited_facts[:bedrooms]
    # details.edited_facts[:bathrooms]
    # details.edited_facts[:finished_sq_ft]
    # details.edited_facts[:lot_size_sq_ft]
    # details.edited_facts[:year_built]
    # details.edited_facts[:images]
    # details.edited_facts[:images_count]
    # details.edited_facts[:homeDetails]   #URL to Zillow Listing
  end

  def catch_upsc
    self.fix_address_and_add_aerial_view
    self.add_defaulted_amount
    self.get_valuation
  end



  validates_attachment_content_type :aerial_image, :content_type => /\Aimage\/.*\Z/
end
