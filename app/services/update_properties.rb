# UpdateProperties gathers current 'active' properties from county assessor's site
# and compares to database, adding and removing entries accordingly

class UpdateProperties
  attr_accessor :properties

  def initialize
    @properties = []
    @tax_page = 'https://www2.sdcounty.ca.gov/treastax/taxsale/taxsale.asp'
  end

  def run
    page = get_active_page
    parcels = get_parcels(page)
    parcel_nodes_array = format_response(parcels)

    create_properties(parcel_nodes_array)
    remove_timeshares
    compare_to_db
  end

  def get_active_page
    mech = Mechanize.new
    mech.get(@tax_page)
    form = mech.page.forms[0]
    form.submit(form.button_with(:value=>'ACTIVE Properties'))
    mech.page.parser
  end

  def get_parcels(page)
    page.css("#Table13") #table with our data in it
  end

  def format_response(parcels)
    array_for_manipulating = []
# put all 'parcel' nodes into an array for easier manipulation
    parcels.children.each do |child|
      array_for_manipulating << child
    end

    array_for_manipulating.select! { |object| !object.attributes.empty? }
    array_for_manipulating.shift(2)
    array_for_manipulating
  end

  def create_properties(array_of_prop_obj)
    array_of_prop_obj.each do |property_object|
      info_hash = {}
      info_hash[:parcel_num] = property_object.children[3].elements[0].text.strip
      info_hash[:name] = property_object.children[5].elements[0].text
      info_hash[:address] = property_object.children[7].elements[0].text
      info_hash[:legal_desc] = property_object.children[9].elements[0].text.strip
      info_hash[:min_bid] = property_object.children[11].elements[0].text
      info_hash[:grid_num] = property_object.children[13].elements[0].text
      prop = Property.new(info_hash)
      @properties << prop
    end
  end

  def remove_timeshares
    keywords = ["TIMESHARE", "EXCL USE", "PERIOD", "SEASON"]
    @properties.each do |property|

         if keywords.any? do |keyword|
              property.legal_desc.include?(keyword)
            end
            @properties.delete(property)
         end
    end
  end

  def compare_to_db
    @properties.each do |prop|
      db_entry = Property.find_by(parcel_num: prop.parcel_num)
      if db_entry.nil?
        prop.save
        puts "property saved"
      end
    end

    db_entries.each do |entry|
      present = false
      @properties.each do |prop|
        if prop.parcel_num == entry.parcel_num
          present = true
          break
        end
      end
      if present == false
        entry.delete
      end
    end
  end

end


# things update properties should do
# get a new list from sdtreastax
# compare that list with the database for any new entries
# insert new entry
