class UpdateZillow

  def initialize
  end

  def run
    find_props_to_update
    get_valuation
    # get_prop_details
  end

  def find_props_to_update
    # Only check zillow for properties that there is an assessment address & zip for -- produces better results
    @props = Property.where("aerial_image_file_name is NOT NULL and zpid is NULL").limit(1)
  end

  def get_valuation
    @props.each do |prop|

        address = prop.address
        zip = prop.assessment.zip

      zillow_api_result = Rubillow::HomeValuation.search_results( {:address => address, :citystatezip => zip} )
      zillow_hash = {}
      # binding.pry
      if zillow_api_result.zpid.nil?
        puts "property not found"
        prop.zpid = "N/A"
      else
        prop.zpid = zillow_api_result.zpid
        zillow_hash[:zestimate] = zillow_api_result.price
        # If prop has a zpid, get full details for zillow_result
        get_prop_details(prop, zillow_hash)
        # binding.pry
        @zillow = ZillowResult.new(zillow_hash)
        prop.zillow_result = @zillow
        @zillow.save
      end
      prop.save
    end
  end

    def get_prop_details(prop, zillow_hash)
      zpid = prop.zpid
      details = Rubillow::PropertyDetails.updated_property_details({ :zpid => zpid })
      zillow_hash[:use_code] = details.edited_facts[:use_code]
      zillow_hash[:bedrooms] = details.edited_facts[:bedrooms]
      zillow_hash[:bathrooms] = details.edited_facts[:bathrooms]
      zillow_hash[:finished_sq_ft] = details.edited_facts[:finished_sq_ft]
      zillow_hash[:lot_size_sq_ft] = details.edited_facts[:lot_size_sq_ft]
      zillow_hash[:year_built] = details.edited_facts[:year_built]
      # details.edited_facts[:images]
      # details.edited_facts[:images_count]
      zillow_hash[:zillow_url] = details.edited_facts[:homeDetails]   #URL to Zillow Listing
    end

    # def get_zestimate
    #   details = Rubillow::PropertyDetails.updated_property_details({ :zpid => zpid })
    #   zillow_hash[:zestimate] = zillow_api_result.price
    # end


end
