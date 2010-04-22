class Migration
  
  def migrate(project_root)
    settings = ProjectSettings.new(project_root)
    count = 0
    Dir.foreach(settings.model_directory) do |m|
      file_path = File.join(settings.model_directory, m)
      full_path = File.expand_path(file_path)
      if File.extname(full_path) == ".rb"
        require "#{full_path}"
        count = count + 1
      end
    end
    DataMapper.setup(:default, "sqlite3://#{settings.database_directory}/development.sqlite3")
    DataMapper.auto_upgrade!
    puts "All #{count} Migrations Complete"
  end
  
end