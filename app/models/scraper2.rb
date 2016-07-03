class Scraper2
  @@url1 = 'https://assr.parcelquest.com/home/county/sdx'
  @@url = 'https://assr.parcelquest.com'

  def scrape(property)

    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    disclaimer_page = a.get(@@url1)
    search_page = disclaimer_page.links[4].click


    search_page.forms.first.field(:name => 'apn').value = property.parcel_num
    results_page = search_page.forms.first.submit


    form = results_page.forms.first
    button = results_page.forms.first.button_with(:value => 'submitResults')



    finally = a.submit(form, button)

    # nokoObject = finally.parser
    #
    # aerial_image_url = nokoObject.css("img")[2].values.first
    #
    # aerial_image_base = "https://assr.parcelquest.com"
    #
    # img_url = aerial_image_base + aerial_image_url



    finally.images[2].fetch.save "lib/assets/test_image.png"

    #  img_binary = File.binread("lib/assets/test_image.png")

    #  property.aerial_image = img_binary.unpack('a')

    # binding.pry

  end

end
