class ModelViewBinding
  
  attr_accessor :model_name, :columns, :associations, :statements
  
  def get_binding
    binding
  end
  
  def convert_associations_to_datamapper_statements
    @statements = Array.new unless @statements
    @associations.each do |entity_name, entity_type|
      case entity_type
      when "has_many"
        @statements << "has n, :#{entity_name.pluralize}"
      when "belongs_to"
        @statements << "belongs_to :#{entity_name}"
      when "has_and_belongs_to_many"
        # TODO
      end
    end
  end
  
end
