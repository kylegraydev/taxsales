class HomeController < ApplicationController
  # before_action :first_visit?
  before_action :set_properties
  # , except: [:update]

  def index
    @properties = @properties_obj.list
  end

  def minor
    @properties_obj.list_only_real_properties
    @properties = @properties_obj.list
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
