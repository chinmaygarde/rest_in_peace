class ViewBinding
  
  attr_accessor :view_name, :fields, :html_tags
  
  def get_binding
    binding
  end
  
  def map_fields_to_html_tags
    @html_tags = Hash.new
    @fields.each do |key, value|
      @html_tags[key] = tag_for_field_type(value)
    end
  end
  
  def tag_for_field_type(type)
    case type
    when "string"
      "text" #for now, only text inputs will work. Really need to think this through.
    else
      "text"
    end
  end
  
end