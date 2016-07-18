class PropertiesController < ApplicationController

  # before_action :first_visit?
  before_action :set_properties
  # , except: [:update]

  def index
    # @properties = @properties_obj.list <<----- for all listings
    @properties_obj.list_only_real_properties
    @properties = @properties_obj.list
  end

  def minor



    # @hash = Gmaps4rails.build_markers() do |user, marker|
    #   marker.lat user.latitude
    #   marker.lng user.longitude
    #
    #
    # end

  end

  def show
    @property = Property.find_by(id: params[:id])

    @hash = Gmaps4rails.build_markers(@property) do |prop, marker|
      marker.lat prop.latitude
      marker.lng prop.longitude
    end

    @images = []
    @images << @property.aerial_image.url

  end

  def update
    # raise @properties.inspect
    @properties_obj.toggle_timeshares
    @properties = @properties_obj.list
    render 'index'
  end

  def set_properties
    @properties_obj = ViewList.new
  end

  # def scrape
  #   @scraper = Scraper.new
  #   @scraper.create_properties_array
  #
  #   keywords = ["TIMESHARE", "EXCL USE", "PERIOD", "SEASON"]
  #
  #   @scraper.properties.select! do |property|
  #     !keywords.any? do |keyword|
  #        property.legal_desc.include?(keyword)
  #      end
  #   end
  #
  #   update_database(@scraper)
  # end
  #
  # def update_database(scraper)
  #
  #         scraper.properties.each do |record|
  #           query = Property.find_by(parcel_num: record.parcel_num)
  #           # binding.pry
  #           if query
  #             record.attributes.each do |attribute, value|
  #                 if record[attribute] != nil
  #                   query[attribute] = value
  #                 end
  #             end
  #             query.save
  #           else
  #             record.save
  #           end
  #         end
  #   redirect_to root_path
  # end

end
