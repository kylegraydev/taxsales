class UpdateTaxBill

  def run
    find_props_to_update
    @props.each do |prop|
      get_amount_owed(prop)
    end
  end

  def find_props_to_update
    @props = Property.where("defaulted_amount is NULL").limit(1)
  end

  def get_amount_owed(property)
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

    # Defauted amount
    amount = response.parser.css('table#PaymentApplicationContent_dataTableDefaulted').css('tr')[2].elements[1].text
    property.defaulted_amount = amount
    property.save
  end

end
