class Property < ActiveRecord::Base
  # include ActionView::Helpers::NumberHelper
  has_one :assessment, :dependent => :destroy
  has_one :zillow_result, :dependent => :destroy

  has_attached_file :aerial_image,
                    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :aerial_image, :content_type => /\Aimage\/.*\Z/

end
