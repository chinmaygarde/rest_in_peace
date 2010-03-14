class ServerManager
  
  def start_server(project_root)
    
    settings = ProjectSettings.new(project_root)
    configure_server(settings)
    Generator.new(project_root).generate_sinatra_app_file
    
    system "rackup #{File.join(settings.config_directory, "config.ru")} -p 4567 -s webrick"
  end
  
  def configure_server(settings)
    #set :app_file, File.expand_path( File.join( settings.config_directory, "boot.rb" ) )
    # set :public,   File.expand_path(File.dirname(__FILE__) + '/../public')
    # set :views, File.expand_path( settings.view_directory )
    #set :environment, :development
    # set :root, File.dirname(__FILE__)
    #set :host, 'localhost'
    #set :run, false

    # require File.dirname(__FILE__) + "/../my_sinatra_app"
    # run Sinatra.application
  end  
end