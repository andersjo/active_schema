require 'set'

module ActiveSchema
  class TableHub
    attr_accessor :tables, :relations
    def initialize
      @tables = {}
      @relations = Hash.new {|h,k| h[k] = Set.new }
    end

    def add_foreign_key(from_table_name, to_table_name, column_name)
      from_table = find_or_create_table(from_table_name)
      to_table   = find_or_create_table(to_table_name)

      add_relation(from_table, to_table)
      from_table.add_foreign_key(column_name, to_table)
    end

    def add_index(table_name, index_def)
      find_or_create_table(table_name).add_index(index_def)
    end

    def add_model(model)
      find_or_create_table(model.table_name).model = model
    end

    private
    def add_relation(from_table, to_table)
      @relations[from_table.name] << to_table
      @relations[to_table.name]   << from_table
    end

    def find_or_create_table(table_name)
      if @tables.has_key?(table_name)
        @tables[table_name]
      else
        @tables[table_name] = Table.new(table_name)
      end
    end

  end
end
