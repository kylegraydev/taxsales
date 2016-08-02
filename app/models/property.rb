class Property < ActiveRecord::Base
  # include ActionView::Helpers::NumberHelper
  has_one :assessment
  has_one :zillow_result

  has_attached_file :aerial_image,
                    styles: { medium: "300x300>", thumb: "100x100>" }

  geocoded_by :address

  validates_attachment_content_type :aerial_image, :content_type => /\Aimage\/.*\Z/
end
