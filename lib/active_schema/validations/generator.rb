module ActiveSchema::Validations
  class ValueGenerator
    def initialize(model)
      @model = model
    end

    def validation(name, column, opts = {})
      @model.send(name, column, opts)
    end

  end
end

require 'active_schema/validations/by_column'
require 'active_schema/validations/by_index'

module ActiveSchema::Validations
  class Generator
    def initialize(table)
      @table = table
      @model = table.model
    end

    def generate
      generate_for_columns
      generate_for_indexes
    end

    def generate_for_columns
      @model.columns.each do |column|
        ByDataType.new(@model, column).generate
        ByNullability.new(@model, column).generate
      end
    end

    def generate_for_indexes
      
    end

  end

end

