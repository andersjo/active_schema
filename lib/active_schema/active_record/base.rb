module ActiveSchema
  module ActiveRecord
    module ClassMethods
      def active_schema(feeder = OnTheFlyFeeder.new)
        @active_schema_activated = true
        ::ActiveRecord::Base.init_active_schema(feeder)
        if self != ::ActiveRecord::Base
          ::ActiveRecord::Base.active_schema_feeder.model_loaded(self)
        end
      end

      def active_schema_activated?
        @active_schema_activated
      end

      def init_active_schema(feeder)
        if @feeder.nil?
          @feeder = feeder
          ::ActiveRecord::Base.add_observer(::ActiveRecord::ModelLoadedObserver.new)
        end
      end

      def active_schema_feeder
        @feeder
      end

    end

    module InstanceMethods
    end
  end
end
  
module ActiveRecord #:nodoc:
  class ModelLoadedObserver
    def update(event, value)
      case event 
      when :observed_class_inherited
        Base.active_schema_feeder.model_loaded(value)
      end
    end
  end

  class Base
    extend  ActiveSchema::ActiveRecord::ClassMethods
    include ActiveSchema::ActiveRecord::InstanceMethods
  end
end

