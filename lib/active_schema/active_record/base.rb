module ActiveSchema
  module ActiveRecord
    module ClassMethods
      def self.extended(klass)
        klass.class_attribute :active_schema_activated
        klass.class_attribute :active_schema_configuration
        klass.active_schema_configuration = ActiveSchema.configuration
      end

      def active_schema
        if !active_schema_activated
          self.active_schema_activated = true
          active_schema_load_model
        end
      end

      def active_schema_load_model
        unless active_schema_configuration.skip_model.call(self)
          active_schema_configuration.feeder.model_loaded(self)
        end
      end

    end

    module InstanceMethods
    end
  end
end

ActiveRecord::Base
module ActiveRecord #:nodoc:
  class ModelLoadedObserver
    def update(event, klass)
      case event 
      when :observed_class_inherited
        klass.active_schema_load_model if klass.active_schema_activated
      end
    end
  end

  class Base
    add_observer ModelLoadedObserver.new
    extend  ActiveSchema::ActiveRecord::ClassMethods
    include ActiveSchema::ActiveRecord::InstanceMethods
  end
end