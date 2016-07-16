class Property < ActiveRecord::Base
  has_attached_file :aerial_image,
                    styles: { medium: "300x300>", thumb: "100x100>" }



  def add_defaulted_amount
    scraper = Scraper3.new
    amt = scraper.scrape(self)
    self.defaulted_amount = amt
    self.save
  end

  validates_attachment_content_type :aerial_image, :content_type => /\Aimage\/.*\Z/
end
