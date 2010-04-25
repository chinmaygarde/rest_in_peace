class ServerManager
  
  def initialize(project_root)
    @settings = ProjectSettings.new(project_root)
  end
  
  def start_server
    
    create_rackup_config
    
    config_options = @settings.get_config_options
    
    puts "--------------------------------------------------------------------------------"
    puts "-------------------- Dead man walking at localhost:#{config_options["server_port"]} ------------------------"
    puts "--------------------------------------------------------------------------------"
    
    system "rackup #{File.join(@settings.project_root, "config.ru")} -p #{config_options["server_port"]} -s #{config_options["server_adapter"]}"
    
  end
  
  def create_rackup_config
    Generator.new(@settings.project_root).generate_rackup_config    
  end
  
end