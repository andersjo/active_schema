module ActiveSchema
  class Feeder
    attr_reader :associations_generator, :validations_generator, :table_hub
    def initialize
      @table_hub = TableHub.new
      @associations_generator = Associations::Generator
      @validations_generator  = Validations::Generator
    end

    def add_model(model)
      table_hub.add_model(model)
    end

    def dispatch_attachments(model)
      table = table_hub.tables[model.table_name]
      generate_validations(table)
      generate_assocations(table)
    end

    def generate_assocations(table)
      table_hub.relations[table.model.table_name].select(&:model).each do |linked_table|
        generate_associations_between(table, linked_table)
      end
    end

    def generate_associations_between(table1, table2)
      generate_directed_associations_between(table1, table2)
      generate_directed_associations_between(table2, table1)
    end

    def generate_validations(table)
      validations_generator.new(table).generate
    end

    def generate_directed_associations_between(table1, table2)
      table1.foreign_keys.each do |column, ref_table|
        if ref_table == table2
          associations_generator.new(table1, ref_table, column).generate
        end
      end
    end

  end
end
