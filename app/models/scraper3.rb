class Scraper3

  def scrape(property)
    url = 'https://iwr.sdtreastax.com/SanDiegoTTCPaymentApplication/Search.aspx'

    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    search_page = a.get(url)

    search_page.form.field_with(:name => "ctl00$PaymentApplicationContent$tbParcelNumber").value = property.parcel_num
    submit_button = search_page.form.submits[3]
    bill_page = a.submit(search_page.form, submit_button)
    a.page.at("#PaymentApplicationContent_gvDefaulted_btnView_0")


    # _EVENTTARGET in the main form
    a.page.form.fields[0].value = "ctl00$PaymentApplicationContent$gvDefaulted$ctl02$btnView"

    # _EVENTVALUE in the main form
    a.page.form.fields[1].value = ''
    response = a.page.form.submit

    # bill_page = response.parser


    # response.parser.css('table#PaymentApplicationContent_dataTableDefaulted')

    # Defauted amount
    amount = response.parser.css('table#PaymentApplicationContent_dataTableDefaulted').css('tr')[2].elements[1].text

    # TODO:   response.parser
    # base_url = "https://iwr.sdtreastax.com/SanDiegoTTCPaymentApplication/DefaultedDetails.aspx?parcelNumber="

    # search_url = base_url + property.parcel_num

    #
    amount
  end

  def get_valuation
    prop = Rubillow::HomeValuation.search_results({:address => '834 E Fallbrook St', :citystatezip => 'california'})
    zestimate = prop.price
  end



end

# test = Scraper3.new
# prop = Property.find_by(id: 1469)
# test.scrape(prop)
