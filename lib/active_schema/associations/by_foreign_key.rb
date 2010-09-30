module ActiveSchema::Associations
  module Naming
    def name_for(model)
      model.name.demodulize.underscore.downcase
    end

    def plural_name_for(model)
      name_for(model).pluralize
    end
  end

  class ByForeignKey
    include Naming
    def initialize(from_model, to_model, key_column, key_column_unique)
      @from_model = from_model
      @to_model = to_model
      @key_column = key_column
      @key_column_unique = key_column_unique
    end

    def association(receiver, method_name, name, opts = {})
      receiver.send(method_name, name, opts)
    end
  end

  class ByForwardForeignKey < ByForeignKey
    def generate
      association @from_model, :belongs_to,
        name_for(@to_model),
        { :class_name => @to_model.name, :foreign_key => @key_column }
    end
  end

  class ByReverseForeignKey < ByForeignKey
    def generate
      if @key_column_unique
        association @to_model, :has_one,
          name_for(@from_model),
          { :class_name => @from_model.name, :foreign_key => @key_column }
      else
        association @to_model, :has_many, 
          plural_name_for(@from_model),
          { :class_name => @from_model.name, :foreign_key => @key_column }
      end

    end

  end

end
