class Property < ActiveRecord::Base
  # attr_accessor :parcel_num, :name, :address, :legal_desc, :min_bid, :grid_num, :assessor_map

  # def create(data_hash)
  #   @parcel_num = data_hash[:parcel_num]
  #   @name = data_hash[:name]
  #   @address = data_hash[:address]
  #   @legal_desc = data_hash[:legal_desc]
  #   @min_bid = data_hash[:min_bid]
  #   @grid_num = data_hash[:grid_num]
  #   @assesors_map = data_hash[:assessor_map]
  # end

  def add_image(img)
    binding.pry
    self.aerial_image = img.read
  end

end
