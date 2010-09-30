require 'active_schema/feeder'

module ActiveSchema
  class OnTheFlyFeeder < Feeder
    def model_loaded(model)
      add_model(model)
      add_indexes(model)
      add_foreign_keys(model)
      dispatch_attachments(model)
    end

    private
    def add_indexes(model)
      model.connection.indexes(model.table_name).each do |index|
        @table_hub.add_index(model.table_name, index)
      end
    end

    def add_foreign_keys(model)
      model.connection.foreign_keys(model.table_name).each do |fk|
        @table_hub.add_foreign_key(fk.from_table, fk.to_table, fk.options[:column])
      end

    end
  end
end
