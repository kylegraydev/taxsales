class PropertiesController < ApplicationController

  def scrape
    @scraper = Scraper.new
    @scraper.create_properties_array
    update_database(@scraper)
  end

  def update_database(scraper)

          scraper.properties.each do |record|
            query = Property.find_by(parcel_num: record.parcel_num)
            # binding.pry
                      if query
                                  record.attributes.each do |attribute, value|
                                              # binding.pry
                                              if record[attribute] != nil
                                                query[attribute] = value
                                              end
                                  end
                          query.save
                      else
                        record.save
                      end
          end
    redirect_to root_path
  end

end
