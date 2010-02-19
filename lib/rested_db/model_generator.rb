require 'erb'

class ModelGenerator
  def ModelGenerator.generate(args_string)
    
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
    model_string = ERB.new(File.open('rested_db/templates/model.rb.erb').read).result(b.get_binding)

    file_path = "dev/#{model_name.capitalize}.rb"

    if File.exists?(file_path)
      p "#{model_name.capitalize}.rb already exists. Migration Skipped."
    else
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