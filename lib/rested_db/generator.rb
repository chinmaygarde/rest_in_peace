class Generator

  attr_accessor :settings
  
  def initialize(root_dir)
    self.settings = ProjectSettings.new(root_dir)
  end

  def generate_project
    
    if File.exists?(settings.project_root)
      puts "A project with that name already exists. Move that project of change the name of the new one."
      return
    end
    
    FileUtils.mkdir(settings.project_root)
    FileUtils.mkdir(settings.app_directory)
    FileUtils.mkdir(settings.controller_directory)
    FileUtils.mkdir(settings.model_directory)
    FileUtils.mkdir(settings.view_directory)
    FileUtils.mkdir(settings.log_directory)
    FileUtils.mkdir(settings.config_directory)
    FileUtils.mkdir(settings.script_directory)
    FileUtils.mkdir(settings.database_directory)
    
    File.open(File.join(settings.project_root, "README"), "w") << File.open(File.join(settings.template_directory, "readme.txt.erb")).read

    define_file = File.open(File.join(settings.script_directory, "define"), "w")
    define_file << File.open(File.join(settings.template_directory, "script", "define")).read

    server_file = File.open(File.join(settings.script_directory, "server"), "w")
    server_file << File.open(File.join(settings.template_directory, "script", "server")).read
    
    migration_file = File.open(File.join(settings.script_directory, "migrate"), "w")
    migration_file << File.open(File.join(settings.template_directory, "script", "migrate")).read

    File.chmod(0755, define_file.path, server_file.path, migration_file.path)
    
    puts "You database is ready to REST."
  end

  def generate_scaffold(*args)
    generate_model(*args)
    generate_controller(args[0])
  end

  def generate_model(*args)

    model_name = args[0]
    columns = Hash.new

    (1 .. (args.length - 1)).each do |i|
      key_value = args[i].split(':')
      columns[key_value[0]] = key_value[1]
    end

    b = ModelViewBinding.new
    b.model_name = model_name
    b.columns = columns

    model_string = ERB.new(File.open( File.join(settings.template_directory, "model.rb.erb") ).read ).result(b.get_binding)

    file_path = File.join(settings.model_directory, "#{model_name.capitalize}.rb")

    if File.exists?(file_path)
      puts "Model #{model_name.capitalize}.rb already exists. Migration Skipped."
    else
      puts "Model #{model_name.capitalize}.rb created."
      outfile = File.open(file_path, "w")
      outfile << model_string
      outfile.close
    end
    
  end
  
  def generate_controller(name)

    b = ControllerViewBinding.new
    b.controller_name = name
    
    controller_string = ERB.new(File.open( File.join(settings.template_directory, "controller.rb.erb") ).read).result(b.get_binding)
    file_path = File.join(settings.controller_directory, "#{name.capitalize}.rb")
    
    if(File.exists?(file_path))
      puts "Controller #{name.capitalize}.rb already exists. Migration Skipped."
    else
      puts "Controller #{name.capitalize}.rb created."
      outfile = File.open(file_path, "w")
      outfile << controller_string
      outfile.close
    end

  end
  
  def generate_sinatra_app_file
    
    app_file = File.open(File.join(settings.config_directory, "boot.rb"), "w")
    
    app_file << line("require 'datamapper'")
    app_file << line("require 'sinatra'")
    
    # Require all models
    Dir.foreach(settings.model_directory) do |m|
      file_path = File.join(settings.model_directory, m)
      full_path = File.expand_path(file_path)
      unless File.directory?(full_path)
        puts "Required #{full_path}"
        app_file << line("require '#{full_path}'")
      end
    end

    # require 'rested_db/helpers'
    # Load all controllers
    Dir.foreach(settings.controller_directory) do |c|
      file_path = File.join(settings.controller_directory, c)
      full_path = File.expand_path(file_path)
      unless File.directory?(full_path)
        puts "Loaded #{full_path}"
        app_file << line("load '#{full_path}'")
      end
    end
    
    app_file.close
    
  end
  
  private
  
  def line(str)
    "#{str}\n"
  end
  
end

class ModelViewBinding
  
  attr_accessor :model_name, :columns
  
  def get_binding
    binding
  end
  
end

class ControllerViewBinding
  
  attr_accessor :controller_name
  
  def get_binding
    binding
  end
  
end