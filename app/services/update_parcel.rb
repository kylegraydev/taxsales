# this service accesses a statewide parcel database through a https proxy. It gathers an aerial map and updates formatting for the address
require 'cgi'
require 'net/http'

class UpdateParcel
  attr_accessor :ip, :port
  #
  def initialize

  end

  def get_ip
    uri = URI('http://gimmeproxy.com/api/getProxy?supportsHttps=true')
    res = Net::HTTP.get(uri)
    hash = JSON.parse(res)
    @ip = hash["ip"]
    @port = hash["port"]
  end

  def get_aerial(property)
    get_ip
    url = 'https://assr.parcelquest.com/home/county/sdx'
    file_path = "lib/assets/aerial_image.png"

    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.set_proxy @ip, @port
    }

    begin
    disclaimer_page = a.get(url)
    rescue SystemCallError
      puts "proxy connection error"
      sleep(1)
      get_ip
      a.set_proxy @ip, @port
      retry
    end

    search_page = disclaimer_page.links[4].click

    search_page.forms.first.field(:name => 'apn').value = property.parcel_num
    results_page = search_page.forms.first.submit

    form = results_page.forms.first
    button = results_page.forms.first.button_with(:value => 'submitResults')

    finally = a.submit(form, button)

    finally.images[2].fetch.save file_path

    fixed_address = finally.css('div#divPclContent0').css('table').css('tr')[3].children[3].text

    property.address = fixed_address

    file = File.open(file_path)
    property.aerial_image = file
    file.close
    property.save
    File.delete(file_path) if File.exist?(file_path)
  end

end