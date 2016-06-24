class ViewList
  attr_accessor :list

  def initialize
    @list = Property.all
  end

  # def self.toggle_timeshares
  #   @@property_list_with_filters = Property.all.select! { |object| !object.text.include?("TIMESHARE") }
  # end

end
