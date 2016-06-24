class ViewList
  attr_accessor :list

  def initialize
    @list = Property.all
  end

  def toggle_timeshares
    keywords = ["TIMESHARE", "EXCL USE", "PERIOD", "SEASON"]
    # @@property_list_with_filters = Property.all.select! { |object| !object.text.include?("TIMESHARE") }
    # raise @list.first.inspect
    @list.select! do |property|
      !keywords.any? do |keyword|
         property.legal_desc.include?(keyword)
       end
    end

  end

end
