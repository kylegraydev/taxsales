class HomeController < ApplicationController
  before_action :first_visit?

  def index
    properties = ViewList.new
    @properties = properties.list
  end

  def minor
  end

  def update
    # Property.toggle_timeshares
    render 'index'
  end

end
