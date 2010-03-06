class RestedController < Sinatra::Base
  # Converts an entity to its XML representation
	def to_xml(entities)
	  content_type("text/xml")
		xml = Builder::XmlMarkup.new
		xml.instruct!
		if entities.class.to_s == "DataMapper::Collection" # Bad idea!, problem to be solved another day :)
		  xml.results do
  		  entities.each do |entity|
  		    convert_entity(entity, xml)
  		  end
		  end
	  else
	    convert_entity(entities, xml)
		end
	end
	
	private
	
	def convert_entity(entity, xml)
		xml.tag!(entity.class.to_s.downcase) do |b|
  		entity.instance_variables.each do |v|
  		  unless v.match(/@_*/).to_s == "@_"
  			  b.tag!(v.gsub("@", ""), entity.instance_variable_get(v))
			  end
  		end
  	end	 
	end
end