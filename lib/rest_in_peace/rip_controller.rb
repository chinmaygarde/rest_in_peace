class RIPController < Sinatra::Base
  set :method_override, true

  def initialize(project_root)
    @settings = ProjectSettings.new(project_root)
  end
  
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
	
	def to_html(view, entity = self.class.to_s)
	  # Check if the view to be displayed is the default one for the controller
    if entity != self.class.to_s
      @parent_entity = self.class.to_s.downcase.gsub("controller", "").strip
    end
    content_type("text/html")
    Sinatra::Base.set(:views, File.join(@settings.view_directory, entity.downcase.gsub("controller", "").strip))
    @yield = erb(view)
    ERB.new(File.open(File.join(@settings.view_directory, "layouts", "application.html.erb")).read).result(binding)
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
