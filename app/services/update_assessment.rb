# this service accesses a statewide parcel database through a https proxy. It gathers an aerial map and updates formatting for the address
require 'cgi'
require 'net/http'

class UpdateAssessment
  attr_accessor :ip, :port

  def run
    # 10.times do
    puts "*** UpdateAssessment ***"
        find_props_to_update
        get_ip
        @props.each do |prop|
          get_aerial(prop)
          get_coordinates(prop)
          sleep(3)
        end
      # end
      puts "*** END UpdateAssessment ***"
  end

  def find_props_to_update
    puts "Finding props"
    @props = Property.where("aerial_image_file_name is NULL").limit(1)
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
        agent.ignore_bad_chunking = true
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
    # property.parcel_num
    finally = search_page.forms.first.submit

# ----------Original site version had a 2 step form system----------------------------
        # form = results_page.forms.first
        # button = results_page.forms.first.button_with(:value => 'submitResults')
        # finally = a.submit(form, button)
# ------------------Saving in case they revert back-----------------------------------

    assessment_hash = {}

    # Use type
    assessment_hash[:use_type] = finally.css('.tblDetails td[4]').children.first.text

    # ASSESSMENTS
    # year assessed
    assessment_hash[:year_assessed] = finally.css('.tblDetails tr[2]').last.children[3].text
    # total land and improvements value
    assessment_hash[:total_value] = finally.css('.tblDetails tr[6] td[2]').text

    # Property Info
    # bedrooms
    assessment_hash[:bdr] = finally.css('.tblDetails tr[10] td[2]').text
    # baths
    assessment_hash[:ba] = finally.css('.tblDetails tr[11] td[2]').text
    # bldg/living area
    assessment_hash[:bldg_sqft] = finally.css('.tblDetails tr[12] td[2]').text
    # year built
    assessment_hash[:year_built] = finally.css('.tblDetails tr[13] td[2]').text
    # lot acres
    assessment_hash[:lot_acres] = finally.css('.tblDetails tr[14] td[2]').text

    # RECENT SALE HISTORY
    # recording date
    assessment_hash[:recording_date] = finally.css('.tblDetails tr[17] td[2]').text
    # sale amount
    assessment_hash[:sale_amount] = finally.css('.tblDetails tr[19] td[2]').text


    fixed_address = finally.css('div#divPclContent0').css('table').css('tr')[3].children[3].text
# ----------Sometimes address will only be listed as "CA", don't save this-----------
    if ( fixed_address.strip.length > 2 )
      puts "adding formatted address"
      street_address = fixed_address[/(.*)\r\n/].strip
      zip = fixed_address[/\r\n(.*)/]
      zip = zip[2..-1]
      zip = zip[/\d.*/]
      # binding.pry
      assessment_hash[:street_address] = street_address
      assessment_hash[:zip] = zip
    end

    @assessment = Assessment.new(assessment_hash)
    property.assessment = @assessment
    @assessment.save

    puts "Saving image locally"
    finally.images[2].fetch.save file_path
    file = File.open(file_path)
    property.aerial_image = file
    file.close
    property.save
    File.delete(file_path) if File.exist?(file_path)
  end

  def get_coordinates(prop)
    coords = Geocoder.coordinates(prop.address + " " + prop.assessment.zip , {} )
    # binding.pry
    prop.latitude = coords[0]
    prop.longitude= coords[1]
    prop.save
  end

end
