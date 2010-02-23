class ServerManager
  
  def start_server(project_root)
    
    settings = ProjectSettings.new(project_root)

    # Load all controllers
    Dir.foreach(settings.controller_directory) do |c|
      file_path = File.join(settings.controller_directory, c)
      full_path = File.expand_path(file_path)
      unless File.directory?(full_path)
        load "#{full_path}"
      end
    end
    
    Sinatra::Server.new.start
    
  end
  
end