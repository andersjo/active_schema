require 'active_schema/feeder'

module ActiveSchema
  class InAdvanceFeeder < Feeder
    def model_loaded(model)
      add_model(model)
      dispatch_attachments(model)
    end
  end
end
