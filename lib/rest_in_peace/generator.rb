class Generator

  attr_accessor :settings
  
  def initialize(root_dir)
    self.settings = ProjectSettings.new(root_dir)
  end

  def generate_project
    
    if File.exists?(settings.project_root)
      puts "A project with that name already exists. Move that project or change the name of the new one."
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
    FileUtils.mkdir(settings.public_directory)
    FileUtils.mkdir(File.join(settings.public_directory, "stylesheets"))
    FileUtils.mkdir(File.join(settings.view_directory, "layouts"))
    FileUtils.cp(File.join(settings.template_directory, "image", "favicon.ico"), settings.public_directory)
    
    File.open(File.join(settings.project_root, "README"), "w") << File.open(File.join(settings.template_directory, "readme.txt.erb")).read

    File.open(File.join(settings.view_directory, "layouts", "application.html.erb"), "w") << File.open(File.join(settings.template_directory, "html", "layout.html.erb")).read

    File.open(File.join(settings.public_directory, "stylesheets", "main.css"), "w") << File.open(File.join(settings.template_directory, "stylesheet", "main.css")).read
    
    define_file = File.open(File.join(settings.script_directory, "define"), "w")
    define_file << File.open(File.join(settings.template_directory, "script", "define")).read

    server_file = File.open(File.join(settings.script_directory, "server"), "w")
    server_file << File.open(File.join(settings.template_directory, "script", "server")).read
    
    migration_file = File.open(File.join(settings.script_directory, "migrate"), "w")
    migration_file << File.open(File.join(settings.template_directory, "script", "migrate")).read

    File.chmod(0755, define_file.path, server_file.path, migration_file.path)
    
    puts "Your project is six feet under at #{settings.project_root}"
  end

  def generate_scaffold(*args)
    generate_model(*args)
    generate_controller(args[0])
    generate_views(*args)
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
    file_path = File.join(settings.controller_directory, "#{name.capitalize}Controller.rb")
    
    if(File.exists?(file_path))
      puts "Controller #{name.capitalize}Controller.rb already exists. Migration Skipped."
    else
      puts "Controller #{name.capitalize}Controller.rb created."
      outfile = File.open(file_path, "w")
      outfile << controller_string
      outfile.close
    end

  end

  
  def generate_views(*args)
    model_name = args[0].downcase
    
    directory = File.join(settings.view_directory, model_name)
    if File.exists?(directory)
      puts "Views for this model already exist. Skipping generation"
    else
      
      v = ViewBinding.new
      v.view_name = model_name
      v.fields = Hash.new
      (1 .. (args.length - 1)).each do |i|
        key_value = args[i].split(':')
        v.fields[key_value[0]] = key_value[1]
      end
      v.map_fields_to_html_tags

      (1 .. (args.length - 1)).each do |i|
        key_value = args[i].split(':')
        v.fields[key_value[0]] = key_value[1]
      end
      
      FileUtils.mkdir(directory)
      index_file = File.open(File.join(directory, "index.erb"), "w")
      index_file << ERB.new(File.open(File.join(settings.template_directory, "html" ,"index.html.erb")).read).result(v.get_binding)
      index_file.close
      
      show_file = File.open(File.join(directory, "show.erb"), "w")
      show_file << ERB.new(File.open(File.join(settings.template_directory, "html" ,"show.html.erb")).read).result(v.get_binding)
      show_file.close
      
      edit_file = File.open(File.join(directory, "edit.erb"), "w")
      edit_file << ERB.new(File.open(File.join(settings.template_directory, "html" ,"edit.html.erb")).read).result(v.get_binding)
      edit_file.close
      
      new_file = File.open(File.join(directory, "new.erb"), "w")
      new_file << ERB.new(File.open(File.join(settings.template_directory, "html" ,"new.html.erb")).read).result(v.get_binding)
      new_file.close
      
      puts "Views Created."
      
    end

    
  end

  
  def generate_rackup_config
    
    app_file = File.open(File.join(settings.config_directory, "config.ru"), "w")
    
    app_file << line("require 'datamapper'")
    app_file << line("require 'rest_in_peace'")
    app_file << line("require 'sinatra/base'")
    app_file << line("require 'builder'")

    # Require all models
    Dir.foreach(settings.model_directory) do |m|
      file_path = File.join(settings.model_directory, m)
      full_path = File.expand_path(file_path)
      
      if File.extname(full_path) == ".rb"
        app_file << line("require '#{full_path}'")
      end
    end
    
    controller_names = []
    # Load all controllers
    Dir.foreach(settings.controller_directory) do |c|
      file_path = File.join(settings.controller_directory, c)
      full_path = File.expand_path(file_path)
      if File.extname(full_path) == ".rb"
        app_file << line("require '#{full_path}'")
        controller_names << File.basename(full_path, File.extname(full_path)).capitalize
      end
    end
    
    app_file << line("Sinatra::Base.set :public, File.join(File.dirname(File.dirname(__FILE__)), 'public')")

    controller_names.each do |controller|
      app_file << line("map \"/#{controller.downcase.gsub("controller", "")}\" do")
        #app_file << line("Sinatra::Base.set :public, File.expand_path(File.join(File.dirname(File.dirname(__FILE__)), 'public'))", 1)
        #app_file << line("p File.expand_path(File.join(File.dirname(File.dirname(__FILE__)), 'public'))", 1)
        app_file << line("DataMapper.setup(:default, \"sqlite3://#{settings.database_directory}/development.sqlite3\")" , 1)
        app_file << line("controller = #{controller.gsub("controller", "Controller")}.new(File.dirname(File.dirname(__FILE__)))", 1)
      	app_file << line("run controller", 1)
      app_file << line("end")
    end

    app_file << line("map \"/public\" do")
      app_file << line("run RIPController.new(File.dirname(File.dirname(__FILE__)))", 1)
    app_file << line("end")
    
    app_file.close
    
  end
  
  private
  
  def line(str, indent=0)
    out_str = ""
    indent.times do
      out_str = out_str + "\t"
    end
    out_str = out_str + str + "\n"
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

class ViewBinding
  
  attr_accessor :view_name, :fields, :html_tags
  
  def get_binding
    binding
  end
  
  def map_fields_to_html_tags
    @html_tags = Hash.new
    @fields.each do |key, value|
      @html_tags[key] = tag_for_field_type(value)
    end
  end
  
  def tag_for_field_type(type)
    case type
    when "string"
      "text" #for now, only text inputs will work. Really need to think this through.
    else
      "text"
    end
  end
  
end