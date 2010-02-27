require 'sinatra'
require 'datamapper'

class ServerManager
  
  def start_server(project_root)
    
    settings = ProjectSettings.new(project_root)
    
    configure_server(settings)
    puts "Trace"
    Generator.new(project_root).generate_sinatra_app_file
    puts File.open(File.join(settings.config_directory, "boot.rb")).read
    Sinatra::Base.run! # Sinatra.application
    puts File.open(File.join(settings.config_directory, "boot.rb")).read    
  end
  
  def configure_server(settings)
    set :app_file, File.expand_path( File.join( settings.config_directory, "boot.rb" ) )
    # set :public,   File.expand_path(File.dirname(__FILE__) + '/../public')
    set :views, File.expand_path( settings.view_directory )
    # set :env,      :production
    disable :run, :reload

     # require File.dirname(__FILE__) + "/../my_sinatra_app"

    # run Sinatra.application
  end  
end