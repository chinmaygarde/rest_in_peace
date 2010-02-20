require 'erb'

class Generator

  attr_accessor :project_root, :app_directory, :controller_directory, :model_directory,
                :view_directory, :log_directory, :config_directory, :template_directory

  def initialize(root_dir)
    
    # Project Specific Paths
    self.project_root = root_dir
    self.app_directory = File.join(root_dir, "app")
    self.controller_directory = File.join(app_directory, "controllers")
    self.model_directory = File.join(app_directory, "models")
    self.view_directory = File.join(app_directory, "views")
    self.log_directory = File.join(project_root, "log")
    self.config_directory = File.join(project_root, "config")
    
    # Gem Specific Paths
    self.template_directory = File.join("#{File.dirname(__FILE__)}", "templates")
  end

  def generate_project
    
    if File.exists?(project_root)
      puts "A project with that name already exists. Move that project of change the name of the new one."
      return
    end
    
    FileUtils.mkdir(project_root)
    FileUtils.mkdir(app_directory)
    FileUtils.mkdir(controller_directory)
    FileUtils.mkdir(model_directory)
    FileUtils.mkdir(view_directory)
    FileUtils.mkdir(log_directory)
    FileUtils.mkdir(config_directory)

    File.open(File.join(project_root, "README"), "w") << File.open(File.join(template_directory, "readme.txt.erb")).read
    
    puts "You database is ready to REST."
  end

  def generate_model(args_string)
    
    args = args_string.split(' ')
    model_name = args[0]
    columns = Hash.new

    (1 .. (args.length - 1)).each do |i|
      key_value = args[i].split(':')
      columns[key_value[0]] = key_value[1]
    end

    b = ModelViewBinding.new
    b.model_name = model_name
    b.columns = columns

    model_string = ERB.new(File.open( File.join(template_directory, "model.rb.erb") ).read ).result(b.get_binding)

    file_path = File.join(model_directory, "#{model_name.capitalize}.rb")

    if File.exists?(file_path)
      puts "#{model_name.capitalize}.rb already exists. Migration Skipped."
    else
      puts "#{model_name.capitalize}.rb created."
      outfile = File.open(file_path, "w")
      outfile << model_string
      outfile.close
    end
    
  end
  
  def generate_project_template
    
  end
  
  
end

class ModelViewBinding
  
  attr_accessor :model_name, :columns
  
  def get_binding
    binding
  end
  
end