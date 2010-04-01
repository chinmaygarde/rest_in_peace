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
    
    FileUtils.cp(File.join(settings.template_directory, "Gemfile"), settings.project_root)
    
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
    
    # TODO: Throw proper error messages
    arguments = parse_arguments(*args)

    generate_model(arguments["entity"], arguments["columns"], arguments["associations"])
    generate_controller(arguments["entity"], arguments["associations"])
    generate_views(arguments["entity"], arguments["columns"])
  end

  def generate_model(model_name, columns, associations)
    
    model_binding = ModelViewBinding.new
    model_binding.model_name = model_name
    model_binding.columns = columns
    model_binding.associations = associations
    model_binding.convert_associations_to_datamapper_statements
    
    model_string = ERB.new(File.open( File.join(settings.template_directory, "model.rb.erb") ).read ).result(model_binding.get_binding)

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
  
  def generate_controller(name, associations)

    b = ControllerViewBinding.new
    b.controller_name = name
    b.dependent_entity = Array.new
    associations.each do |associated_entity, association_type|
      if association_type == "has_many"
        b.dependent_entity << associated_entity
      end
    end
    
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

  
  def generate_views(model_name, columns)

    directory = File.join(settings.view_directory, model_name)
    if File.exists?(directory)
      puts "Views for this model already exist. Skipping generation"
    else
      
      v = ViewBinding.new
      v.view_name = model_name
      v.fields = columns
      v.map_fields_to_html_tags

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
      
      puts "Views for #{model_name.capitalize} Created."
      
    end

    
  end

  
  def generate_rackup_config
    
    app_file = File.open(File.join(settings.project_root, "config.ru"), "w")
    
    app_file << line("require 'datamapper'")
    app_file << line("require 'rest_in_peace'")
    app_file << line("require 'sinatra/base'")
    app_file << line("require 'builder'")

    # Require all models
    Dir.foreach(settings.model_directory) do |m|
      file_path = File.join(settings.model_directory, m)
      full_path = File.expand_path(file_path)
      
      if File.extname(full_path) == ".rb"
        app_file << line("require '#{full_path.gsub(settings.project_root + "/", "")}'")
      end
    end
    
    controller_names = []
    # Load all controllers
    Dir.foreach(settings.controller_directory) do |c|
      file_path = File.join(settings.controller_directory, c)
      full_path = File.expand_path(file_path)
      if File.extname(full_path) == ".rb"
        app_file << line("require '#{full_path.gsub(settings.project_root + "/", "")}'")
        controller_names << File.basename(full_path, File.extname(full_path)).capitalize
      end
    end
    
    app_file << line("Sinatra::Base.set :public, File.join(File.dirname(__FILE__), 'public')")

    controller_names.each do |controller|
      app_file << line("map \"/#{controller.downcase.gsub("controller", "")}\" do")
        #app_file << line("Sinatra::Base.set :public, File.expand_path(File.join(File.dirname(File.dirname(__FILE__)), 'public'))", 1)
        #app_file << line("p File.expand_path(File.join(File.dirname(File.dirname(__FILE__)), 'public'))", 1)
        app_file << line("DataMapper.setup(:default,  ENV['DATABASE_URL'] || \"sqlite3://#{settings.database_directory}/development.sqlite3\")" , 1)
        app_file << line("controller = #{controller.gsub("controller", "Controller")}.new(File.dirname(__FILE__))", 1)
      	app_file << line("run controller", 1)
      app_file << line("end")
    end

    app_file << line("map \"/public\" do")
      app_file << line("run RIPController.new(File.dirname(__FILE__))", 1)
    app_file << line("end")
    
    app_file.close
    
  end
  
  private
  
  def parse_arguments(*args)
    arguments = Hash.new
    
    # First argument has to be entity name
    arguments["entity"] = args[0].downcase

    
    columns = Hash.new
    associations = Hash.new
    
    # Iterate over rest of the arguments
    (1 .. (args.length - 1)).each do |index|
      key_value = args[index].split(':')
      key_value[0] = key_value[0].downcase
      key_value[1] = key_value[1].downcase.singularize
      
      # Check if argument is part a known association
      if key_value[0] == "has_many" || key_value[0] == "belongs_to" || key_value[0] == "has_and_belongs_to_many"
        associations[key_value[1]] = key_value[0] # Key is the name of the entity
      else
        columns[key_value[0]] = key_value[1]          
      end
    end
    
    arguments["columns"] = columns
    arguments["associations"] = associations
    
    return arguments
  end
  
  def line(str, indent=0)
    out_str = ""
    indent.times do
      out_str = out_str + "\t"
    end
    out_str = out_str + str + "\n"
  end
  
end
