class PropertiesController < ApplicationController

  before_action :set_properties

  def index
    # @properties = @properties_obj.list <<----- for all listings
    @properties_obj.list_only_real_properties
    @properties = @properties_obj.list
    @hash = Gmaps4rails.build_markers(@properties) do |prop, marker|
      if !prop.latitude.nil?
        marker.lat prop.latitude
        marker.lng prop.longitude
      end
    end
    @properties = @properties.first(6)
  end

  def show
    @property = Property.find_by(id: params[:id])

    # @hash = Gmaps4rails.build_markers(@property) do |prop, marker|
    #   marker.lat prop.latitude
    #   marker.lng prop.longitude
    #   marker.picture({
    #       "url" => "http://people.mozilla.com/~faaborg/files/shiretoko/firefoxIcon/firefox-32.png",
    #       "width" =>  32,
    #       "height" => 32
    #   })

    @marker = [ @property.latitude, @property.longitude ]

    # @images = []
    # @images << @property.aerial_image.url

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

end
