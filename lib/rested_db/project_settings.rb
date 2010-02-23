class ProjectSettings
  
  attr_accessor :project_root, :app_directory, :controller_directory, :model_directory,
                :view_directory, :log_directory, :config_directory, :template_directory,
                :script_directory, :database_directory
                
  def initialize(root_dir)
    
    # Project Specific Paths
    self.project_root = File.expand_path(root_dir)
    self.app_directory = File.join(root_dir, "app")
    self.controller_directory = File.join(app_directory, "controllers")
    self.model_directory = File.join(app_directory, "models")
    self.view_directory = File.join(app_directory, "views")
    self.log_directory = File.join(project_root, "log")
    self.config_directory = File.join(project_root, "config")
    self.script_directory = File.join(project_root, "script")
    self.database_directory = File.join(project_root, "db")
    
    # Gem Specific Paths
    self.template_directory = File.join("#{File.dirname(__FILE__)}", "templates")
    
  end
  
end