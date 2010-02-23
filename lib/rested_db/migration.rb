# TODO: Don't know why I can't remove this !!
require 'datamapper'

class Migration
  
  def migrate(project_root)
    settings = ProjectSettings.new(project_root)
    Dir.foreach(settings.model_directory) do |m|
      file_path = File.join(settings.model_directory, m)
      full_path = File.expand_path(file_path)
      unless File.directory?(full_path)
        require "#{full_path}"
      end
    end
    DataMapper.setup(:default, "sqlite3://#{settings.database_directory}/development.sqlite3")
    DataMapper.auto_migrate!
    puts "Migrations Complete"
  end
  
end