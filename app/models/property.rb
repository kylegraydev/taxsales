class Property < ActiveRecord::Base
  # include ActionView::Helpers::NumberHelper

  has_attached_file :aerial_image,
                    styles: { medium: "300x300>", thumb: "100x100>" }

  geocoded_by :address
  # before_save :geocode, only: :add_lat_long

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



  # def add_lat_long
  #   self.save
  # end




  validates_attachment_content_type :aerial_image, :content_type => /\Aimage\/.*\Z/
end
