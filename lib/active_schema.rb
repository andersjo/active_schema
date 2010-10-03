require 'active_support/core_ext/string/inflections'

require 'active_schema/configuration'
require 'active_schema/on_the_fly_feeder'
require 'active_schema/in_advance_feeder'
require 'active_schema/schema_feeder'

require 'active_schema/table'
require 'active_schema/table_hub'


require 'active_schema/validations/generator'
require 'active_schema/associations/generator'
require 'active_schema/associations/by_foreign_key'


module ActiveSchema
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
end

require 'active_record'
require 'active_record/base'
require 'active_schema/active_record/base'

