module ActiveSchema
  class ForeignKeyDef < Struct.new(:src_table, :dst_table, :column, :opts); end

  class Configuration
    attr_reader :foreign_keys
    def initialize
      @foreign_keys = []
    end

    def add_foreign_key(src_table, dst_table, opts = {})
      @foreign_keys << ForeignKeyDef.new(src_table, dst_table, opts[:column], opts)
    end

    def foreign_keys_from(table)
      @foreign_keys.select {|fk| fk.src_table == table }
    end

    def foreign_keys_to(table)
      @foreign_keys.select {|fk| fk.dst_table == table }
    end

  end
end
