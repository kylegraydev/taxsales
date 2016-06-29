class Scraper2
  @@url1 = 'https://assr.parcelquest.com/home/county/sdx'
  @@url = 'https://assr.parcelquest.com'

  def scrape

    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    disclaimer_page = a.get(@@url1)
    search_page = disclaimer_page.links[4].click


    search_page.forms.first.field(:name => 'apn').value = '1055310100'
    results_page = search_page.forms.first.submit


    form = results_page.forms.first
    button = results_page.forms.first.button_with(:value => 'submitResults')

    finally = a.submit(form, button)

    finally.parser

    binding.pry

  end

end
