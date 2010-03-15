class ServerManager
  
  def start_server(project_root)
    
    settings = ProjectSettings.new(project_root)
  
    Generator.new(project_root).generate_rackup_config
    
    puts "--------------------------------------------------------------------------------"
    puts "--------------------------------------------------------------------------------"
    puts "-------------------- Dead man walking at localhost:4567 ------------------------"
    puts "--------------------------------------------------------------------------------"
    puts "--------------------------------------------------------------------------------"
    system "rackup #{File.join(settings.config_directory, "config.ru")} -p 4567 -s webrick"
    
  end
  
end