class UpdateZillow

  def initialize
  end

  def run
    find_props_to_update
    get_valuation
    # get_prop_details
  end

  def find_props_to_update
    @props = Property.where("aerial_image_file_name is NOT NULL and zpid is NULL")
  end

  def get_valuation
    @props.each do |prop|
      address = prop.address
      zillow_result = Rubillow::HomeValuation.search_results({:address => address, :citystatezip => 'california'})
      # binding.pry
      if zillow_result.zpid.nil?
        puts "property not found"
        prop.zillow_result.zpid = "N/A"
      else
        prop.zillow_result.zpid = zillow_result.zpid
        prop.zillow_result.zestimate = zillow_result.price
        get_prop_details(prop)
        puts prop
      end
      prop.save
    end

  end

    def get_prop_details(prop)
      zpid = prop.zillow_result.zpid
      details = Rubillow::PropertyDetails.updated_property_details({ :zpid => zpid })
      prop.zillow_result.use_code = details.edited_facts[:use_code]
      prop.zillow_result.bedrooms = details.edited_facts[:bedrooms]
      prop.zillow_result.bathrooms = details.edited_facts[:bathrooms]
      prop.zillow_result.finished_sq_ft = details.edited_facts[:finished_sq_ft]
      prop.zillow_result.lot_size_sq_ft = details.edited_facts[:lot_size_sq_ft]
      prop.zillow_result.year_built = details.edited_facts[:year_built]
      # details.edited_facts[:images]
      # details.edited_facts[:images_count]
      prop.zillow_result.zillow_url = details.edited_facts[:homeDetails]   #URL to Zillow Listing
    end

end
