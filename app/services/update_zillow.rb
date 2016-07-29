class UpdateZillow

  def initialize
  end

  def run
    find_props_to_update
    get_valuation
    # get_prop_details
  end

  def find_props_to_update
    @props = Property.where("aerial_image_file_name is NULL and zpid is NULL").limit(10)
  end

  def get_valuation
    @props.each do |prop|
      address = prop.address
      zillow_result = Rubillow::HomeValuation.search_results({:address => address, :citystatezip => 'california'})
      # binding.pry
      if zillow_result.zpid.nil?
        puts "property not found"
        prop.zpid = "N/A"
      else
        prop.zpid = zillow_result.zpid
        prop.zestimate = zillow_result.price
        get_prop_details(prop)
        puts prop
      end
      prop.save
    end

  end

    def get_prop_details(prop)
      zpid = prop.zpid
      details = Rubillow::PropertyDetails.updated_property_details({ :zpid => zpid })
      prop.use_code = tails.edited_facts[:use_code]
      prop.bedrooms = details.edited_facts[:bedrooms]
      prop.bathrooms = details.edited_facts[:bathrooms]
      prop.finished_sq_ft = details.edited_facts[:finished_sq_ft]
      prop.lot_size_sq_ft = details.edited_facts[:lot_size_sq_ft]
      prop.year_built = details.edited_facts[:year_built]
      # details.edited_facts[:images]
      # details.edited_facts[:images_count]
      prop.zillow_url = details.edited_facts[:homeDetails]   #URL to Zillow Listing
    end

end
