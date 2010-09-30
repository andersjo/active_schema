module ActiveSchema::Validations
  class ByColumn < ValueGenerator
    def initialize(model, column)
      super(model)
      @column = column
    end

    def validation(name, opts = {})
      super(name, @column.name.to_sym, opts)
    end

  end

  class ByDataType < ByColumn
    def generate
      if @column.type == :integer
        validation :validates_numericality_of, {:allow_nil => true, :only_integer => true}
      elsif @column.number?
        validation :validates_numericality_of, {:allow_nil => true}
      elsif @column.text? && @column.limit
        validation :validates_length_of, {:allow_nil => true, :maximum => @column.limit}
      elsif @column.type == :enum
        # Support MySQL ENUM type as provided by the enum_column plugin
        validation :validates_inclusion_of, :in => @column.limit
      end
    end
  end

  class ByNullability < ByColumn
    def generate
      if not @column.null
        if @column.type == :boolean
          validation :validates_inclusion_of, :in => [true, false]
        else
          validation :validates_presence_of
        end
      end
    end
  end

end
