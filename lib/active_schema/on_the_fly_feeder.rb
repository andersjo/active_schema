module ActiveSchema
  class OnTheFlyFeeder
    def initialize(table_hub, dispatcher)
      @table_hub = table_hub
      @dispatcher = dispatcher
    end

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

    def add_model(model)
      @table_hub.add_model(model)
    end

    def dispatch_attachments(model)
      table = @table_hub.tables[model.table_name]
      @dispatcher.attach_validations(table)
      @dispatcher.attach_associations(table)
      @table_hub.relations[model.table_name].select(&:model).each do |linked_table|
        @dispatcher.attach_associations_between(table, linked_table)
      end
    end

  end
end
