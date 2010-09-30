module ActiveSchema
  class AttachmentDispatcher
    include Validations
    include Associations
    attr_accessor :associations_generator, :validations_generator
    def initialize
      @associations_generator = Associations::Generator
      @validations_generator  = Validations::Generator
    end
    
    def attach_associations(table)
      table.foreign_keys.each do |column, ref_table|
        next if ref_table.model.nil?
        @associations_generator.new(table, ref_table, column).generate
      end
    end

    def attach_associations_between(table1, table2)
      attach_directed_associations_between(table1, table2)
      attach_directed_associations_between(table2, table1)
    end

    def attach_validations(table)
      @validations_generator.new(table).generate
    end

    private
    def attach_directed_associations_between(table1, table2)
      table1.foreign_keys.each do |column, ref_table|
        if ref_table == table2
          @associations_generator.new(table1, ref_table, column).generate
        end
      end
    end

  end
end
