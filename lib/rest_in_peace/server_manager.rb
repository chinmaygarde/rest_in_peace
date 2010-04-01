class ServerManager
  
  def start_server(project_root)
    
    settings = ProjectSettings.new(project_root)
  
    Generator.new(project_root).generate_rackup_config
    config_options = YAML::load(File.open(File.join(settings.config_directory, "config.yml"), "r").read)
    puts "--------------------------------------------------------------------------------"
    puts "-------------------- Dead man walking at localhost:#{config_options["server_port"]} ------------------------"
    puts "--------------------------------------------------------------------------------"
    system "rackup #{File.join(settings.project_root, "config.ru")} -p #{config_options["server_port"]} -s #{config_options["server_adapter"]}"
    
  end
  
end