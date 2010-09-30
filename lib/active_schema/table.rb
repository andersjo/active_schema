# To change this template, choose Tools | Templates
# and open the template in the editor.
module ActiveSchema
  class Table
    attr_accessor :name, :model, :foreign_keys, :indexes
    def initialize(name, model = nil)
      @name  = name
      @model = model
      @foreign_keys = {}
      @indexes = []
    end
    
    def add_foreign_key(column, dst_table)
      @foreign_keys[column] = dst_table
    end
    
    def add_index(index)
      @indexes << index
    end

    def unique_index_on?(column)
      @indexes.any? do |idx|
        idx.columns.size == 1 &&
          idx.columns.first == column &&
          idx.unique
      end
    end

  end
end
