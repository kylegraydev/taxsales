class Scraper3

  def scrape(property)
    url = 'https://iwr.sdtreastax.com/SanDiegoTTCPaymentApplication/Search.aspx'

    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    search_page = a.get(url)
    search_page.form.field_with(:name => "ctl00$PaymentApplicationContent$tbParcelNumber").value = "1055310100"
    submit_button = search_page.form.submits[3]
    bill_page = a.submit(search_page.form, submit_button)
    # a.page.at("#PaymentApplicationContent_gvDefaulted_btnView_0")


    # _EVENTTARGET in the main form
    a.page.form.fields[0].value = "ctl00$PaymentApplicationContent$gvSecured$ctl02$btnView"

    # _EVENTVALUE in the main form
    # a.page.form.fields[1].value = ''

    response = a.page.form.submit

    binding.pry
    TODO:   response.parser

  end

end

# test = Scraper3.new
# prop = Property.find_by(id: 1469)
# test.scrape(prop)
