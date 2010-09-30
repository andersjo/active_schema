# To change this template, choose Tools | Templates
# and open the template in the editor.

module ActiveSchema
  module Associations
    class Generator
      def initialize(from_table, to_table, column_name)
        @from_table   = from_table
        @to_table     = to_table
        @column_name  = column_name
      end

      def generate
        [ByForwardForeignKey, ByReverseForeignKey].each do |generators|
          generators.new(@from_table.model,
            @to_table.model,
            @column_name,
            @from_table.unique_index_on?(@column_name)).generate
          
        end
      end

    end
  end
end
