module ActiveSchema
  class Configuration
    attr_accessor :feeder,
      :skip_validation_for_column,
      :skip_model

    def initialize
      self.feeder = OnTheFlyFeeder.new(self)
      self.skip_validation_for_column = proc {|column|
        column.name =~ /^(((created|updated)_(at|on))|position)$/
      }
      self.skip_model = proc {|model|
        model == ::ActiveRecord::Base ||
          (model.respond_to?(:abstract_class?) && model.abstract_class?)
      }
    end

  end
end

