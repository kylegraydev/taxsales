class UpdateZillow

  def initialize
  end

  def get_valuation
    @properties = Property.all
    @properties.each do |prop|
      address = prop.address
      zillow_result = Rubillow::HomeValuation.search_results({:address => address, :citystatezip => 'california'})
      prop.zpid = zillow_result.zpid
      prop.zestimate = zillow_result.price
      prop.save
    end
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

end