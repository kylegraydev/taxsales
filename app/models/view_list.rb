class ViewList
  attr_accessor :list

  def initialize
    @list = Property.all
  end

  def list_only_real_properties
    props = self.list.to_a
    props.reject! { |prop| prop.aerial_image_file_name.nil? }
    self.list = props
  end


end
