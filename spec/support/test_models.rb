module TableClassMethods
  def table_with_indexes
    tbl = ActiveSchema::Table.new(table_name, self)
    connection.indexes(table_name).each {|index| tbl.add_index(index) }
    tbl
  end
end

class Prisoner < ActiveRecord::Base; end
class Warden < ActiveRecord::Base; end
class Facility < ActiveRecord::Base; end
[Prisoner, Warden, Facility].each {|cls| cls.extend(TableClassMethods) }
