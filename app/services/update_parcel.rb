# this service accesses a statewide parcel database through a https proxy. It gathers an aerial map and updates formatting for the address
require 'cgi'
require 'net/http'

class UpdateParcel
  attr_accessor :ip, :port

  def initialize
  end

  def run
    find_props_to_update
    get_ip
    @props.each do |prop|
      get_aerial(prop)
      sleep(1)
    end
  end

  def find_props_to_update
    puts "Finding props"
    @props = Property.where("aerial_image_file_name is NULL").limit(10)
  end

  def get_ip
    puts "getting IP"
    uri = URI('http://gimmeproxy.com/api/getProxy?supportsHttps=true')
    res = Net::HTTP.get(uri)
    hash = JSON.parse(res)
    @ip = hash["ip"]
    @port = hash["port"]
  end

  def get_aerial(property)

    url = 'https://assr.parcelquest.com/home/county/sdx'
    file_path = "lib/assets/aerial_image.png"
  begin
  puts "Mechanizing"

    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.open_timeout = 5
      agent.set_proxy @ip, @port
    }

    a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    disclaimer_page = a.get(url)
  rescue SystemCallError, StandardError
      puts "proxy connection error"
      sleep(1)
      get_ip
      a.set_proxy @ip, @port
      retry
    end

    search_page = disclaimer_page.links[4].click

    search_page.forms.first.field(:name => 'apn').value = property.parcel_num
    finally = search_page.forms.first.submit
# ----------Original site version had a 2 step form system----------------------------
        # form = results_page.forms.first
        # button = results_page.forms.first.button_with(:value => 'submitResults')
        # finally = a.submit(form, button)
# ------------------------------------------------------------------------------------
    puts "Saving image locally"

    finally.images[2].fetch.save file_path
    puts "Fixing address"
    # binding.pry
    fixed_address = finally.css('div#divPclContent0').css('table').css('tr')[3].children[3].text

# ----------Sometimes address will only be listed as "CA", don't save this-----------
    if ( fixed_address.strip.length > 2 )
      property.address = fixed_address
    end

    file = File.open(file_path)
    property.aerial_image = file
    file.close
    property.save
    File.delete(file_path) if File.exist?(file_path)
  end

end
