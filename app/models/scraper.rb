class Scraper

  @@tax_page = 'https://www2.sdcounty.ca.gov/treastax/taxsale/taxsale.asp'

  def get_active_page
    mech = Mechanize.new
    mech.get(@@tax_page)
    form = mech.page.forms[0]
    form.submit(form.button_with(:value=>'ACTIVE Properties'))
    mech.page.parser
  end

  def get_parcels
    page = get_active_page
    page.css("#Table13") #table with our data in it
  end

  def remove_timeshares
    parcels = get_parcels
    array_for_manipulating = []
    parcels.children.each do |child|
      array_for_manipulating << child
    end
    array_for_manipulating.select! { |object| !object.attributes.empty? }
    # array_for_manipulating.select! { |object| !object.text.include?("TIMESHARE") }
    # array_for_manipulating.select! { |object| !object.text.include?("SEASON") }
    # array_for_manipulating.select! { |object| !object.text.include?("YEAR") }
    array_for_manipulating.shift(2)
    array_for_manipulating
  end

  def create_properties
    array_of_prop_obj = remove_timeshares
    properties = []

    array_of_prop_obj.each do |property_object|
      info_hash = {}
      info_hash[:parcel_num] = property_object.children[3].elements[0].text.strip
      info_hash[:name] = property_object.children[5].elements[0].text
      info_hash[:address] = property_object.children[7].elements[0].text
      info_hash[:legal_desc] = property_object.children[9].elements[0].text.strip
      info_hash[:min_bid] = property_object.children[11].elements[0].text
      info_hash[:grid_num] = property_object.children[13].elements[0].text
      info_hash[:assessor_map] = property_object.children[15].elements[0].elements[0].attribute('href').value
      prop = Property.new(info_hash)
      properties << prop
    end
    properties
  end

end
