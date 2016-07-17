class ViewList
  attr_accessor :list

  def initialize
    @list = Property.all
  end

  def toggle_timeshares
    keywords = ["TIMESHARE", "EXCL USE", "PERIOD", "SEASON"]
    @list.select! do |property|

      !keywords.any? do |keyword|
         property.legal_desc.include?(keyword)
       end
       
    end
  end

  def list_only_real_properties
    props = self.list.to_a
    props.reject! {|prop| prop.attributes.values.any? {|x| x.nil?} }
    self.list = props
  end


end
