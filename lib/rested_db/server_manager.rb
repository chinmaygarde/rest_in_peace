require 'sinatra'
require 'datamapper'

class ServerManager
  
  def start_server(project_root)
    
    settings = ProjectSettings.new(project_root)

    configure_server(settings)
    
    require 'rested_db/helpers'
    
    get '/foo' do
      "Bar!"
    end
    
    # Load all controllers
    Dir.foreach(settings.controller_directory) do |c|
      file_path = File.join(settings.controller_directory, c)
      full_path = File.expand_path(file_path)
      unless File.directory?(full_path)
        puts "Loaded #{full_path}"
        load "#{full_path}"
      end
    end
    
    # Require all models
    Dir.foreach(settings.model_directory) do |m|
      file_path = File.join(settings.model_directory, m)
      full_path = File.expand_path(file_path)
      unless File.directory?(full_path)
        puts "Required #{full_path}"
        require "#{full_path}"
      end
    end
    Sinatra::Base.run! # Sinatra.application
    
  end
  
  def configure_server(settings)
    set :app_file, File.expand_path(File.dirname(__FILE__) + '/../my_sinatra_app.rb')
    # set :public,   File.expand_path(File.dirname(__FILE__) + '/../public')
    set :views, File.expand_path( settings.view_directory )
    # set :env,      :production
    disable :run, :reload

     # require File.dirname(__FILE__) + "/../my_sinatra_app"

    # run Sinatra.application
  end  
end