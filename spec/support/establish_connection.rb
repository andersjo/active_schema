ActiveRecord::Base.establish_connection({
  :adapter  => 'mysql2',
  :database => 'active_schema_test',
  :user     => 'mysql'

})

require 'foreigner'
