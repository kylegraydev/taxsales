class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

def first_visit?
  if session[:first_visit].nil?
    session[:first_visit] = 1
    @scraper = Scraper.new
    @scraper.create_properties
  end
end

end
