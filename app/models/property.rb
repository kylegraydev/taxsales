class Property < ActiveRecord::Base
  has_attached_file :aerial_image,
                    styles: { medium: "300x300>", thumb: "100x100>" }






  # def s3_credentials
  #   {:bucket => "xxx", :access_key_id => "xxx", :secret_access_key => "xxx"}
  # end
  validates_attachment_content_type :aerial_image, :content_type => /\Aimage\/.*\Z/
end
