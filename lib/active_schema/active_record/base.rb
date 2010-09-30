module ActiveSchema
  module ActiveRecord
    module ClassMethods
      def active_schema
        @active_schema_activated = true
        ::ActiveRecord::Base.init_active_schema
        if self != ::ActiveRecord::Base
          ::ActiveRecord::Base.active_schema_attacher.model_loaded(self)
        end
      end

      def active_schema_activated?
        @active_schema_activated
      end

      def init_active_schema
        @attacher ||= OnTheFlyFeeder.new(TableHub.new, AttachmentDispatcher.new)
      end

      def active_schema_attacher
        @attacher
      end

      # FIXME: it may not be safe to replace this method
#      def inherited(subclass)
#        puts "inherited: and activating #{subclass}"
#        subclass.active_schema if subclass.active_schema_activated?
#      end


    end

    module InstanceMethods
    end
  end
end
  
module ActiveRecord #:nodoc:
  class Base
#    add_observer
    extend  ActiveSchema::ActiveRecord::ClassMethods
    include ActiveSchema::ActiveRecord::InstanceMethods
  end
end