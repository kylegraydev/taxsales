class Scraper2

  def scrape(property)
    url = 'https://assr.parcelquest.com/home/county/sdx'
    file_path = "lib/assets/aerial_image.png"

    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    disclaimer_page = a.get(url)
    search_page = disclaimer_page.links[4].click

    search_page.forms.first.field(:name => 'apn').value = property.parcel_num
    results_page = search_page.forms.first.submit

    form = results_page.forms.first
    button = results_page.forms.first.button_with(:value => 'submitResults')

    finally = a.submit(form, button)

    finally.images[2].fetch.save file_path
    file = File.open(file_path)
    property.aerial_image = file
    file.close
    property.save
    File.delete(file_path) if File.exist?(file_path)
  end

end
