  class Property
  attr_accessor :parcel_num, :name, :address, :legal_desc, :min_bid, :grid_num, :assessor_map

  @@all_properties = []

  def initialize(data_hash)
    @parcel_num = data_hash[:parcel_num]
    @name = data_hash[:name]
    @address = data_hash[:address]
    @legal_desc = data_hash[:legal_desc]
    @min_bid = data_hash[:min_bid]
    @grid_num = data_hash[:grid_num]
    @assesors_map = data_hash[:assessor_map]
    @@all_properties << self
  end

  def self.all
    @@all_properties
  end

end
