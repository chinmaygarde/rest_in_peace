class RestedController < Sinatra::Base
  # Converts an entity to its XML representation
	def to_xml(entity)
		builder = Builder::XmlMarkup.new
		xml  = builder.tag!(entity.class.to_s.downcase) do |b|
  		entity.instance_variables.each do |v|
  			b.tag!(v.gsub("@", ""), entity.instance_variable_get(v))
  		end
  	end	
	end
end