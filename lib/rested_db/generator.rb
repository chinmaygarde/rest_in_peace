require 'erb'

class Generator
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
    model_string = ERB.new(File.open("#{File.dirname(__FILE__)}/templates/model.rb.erb").read).result(b.get_binding)

    file_path = "/Users/Buzzy/Desktop/dev/#{model_name.capitalize}.rb"

    if File.exists?(file_path)
      p "#{model_name.capitalize}.rb already exists. Migration Skipped."
    else
      p "#{model_name.capitalize}.rb created."
      outfile = File.open(file_path, "w")
      outfile << model_string
      outfile.close
    end

  end
end

class ModelViewBinding
  
  attr_accessor :model_name, :columns
  
  def get_binding
    binding
  end
  
end