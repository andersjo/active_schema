require 'active_schema/in_advance_feeder'

module ActiveSchema
  class FilteredSchemaReader
    def initialize(schema_feeder, schema)
      @schema_feeder = schema_feeder
      @schema = schema
    end

    def filtered_lines
      @schema.split.grep /^\s*(add_index|add_foreign_key)/
    end

    def evaluate
      @schema_feeder.instance_eval(filtered_lines*"\n")
    end

  end

  class SchemaFeeder < InAdvanceFeeder
    def add_index(table_name, column_name, options = {})
      index = ::ActiveRecord::ConnectionAdapters::IndexDefinition\
        .new(table_name, options[:name], options[:unique], Array(column_name), options[:lengths])
      table_hub.add_index(table_name, index)
    end

    def add_foreign_key(from_table, to_table, options = {})
      column = options[:column] ? options[:column] : "#{to_table.singularize}_id"
      table_hub.add_foreign_key(from_table, to_table, column)
    end

    def read(schema)
      FilteredSchemaReader.new(self, schema).evaluate
    end

    def feed
      yield self
    end

  end
end