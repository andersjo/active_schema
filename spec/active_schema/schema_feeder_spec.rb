require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveSchema
describe SchemaFeeder do
  before(:each) do
    @table_hub = ActiveSchema::TableHub.new
    @schema_feeder = SchemaFeeder.new
    @schema_feeder.stub!(:table_hub).and_return(@table_hub)
  end

  context "add_index" do
    after do
      @schema_feeder.add_index "facilities", ["warden_id"], :name => "warden_id", :unique => true
    end

    it "adds an IndexDefinition to TableHub" do
      @table_hub.should_receive(:add_index).with('facilities', instance_of(ActiveRecord::ConnectionAdapters::IndexDefinition))
    end
  end

  context "add_foreign_key" do
    after do
      @schema_feeder.add_foreign_key "facilities", "wardens", :name => "facilities_warden_id"
    end

    it "guesses the foreign key column name if not supplied" do
      @table_hub.should_receive(:add_foreign_key).with(anything, anything, "warden_id")
    end

    it "adds a foreign key to TableHub" do
      @table_hub.should_receive(:add_foreign_key).with('facilities', 'wardens', "warden_id")
    end

  end

  context "reading the contents of a schema file" do 
    it "receives appropriate callbacks" do
      @schema_feeder.should_receive(:add_index).exactly(4).times
      @schema_feeder.should_receive(:add_foreign_key).exactly(3).times
      @schema_feeder.read(EXAMPLE_SCHEMA)
    end

  end
end

describe FilteredSchemaReader do
  before do
    @call_back = mock("SchemaFeeder")
    @filtered_schema_reader = FilteredSchemaReader.new(@call_back, EXAMPLE_SCHEMA)
  end

  it "contains only lines matching filter" do
    @filtered_schema_reader.filtered_lines.size.should == 7
  end

  it "makes callbacks to the supplied object" do
    @call_back.should_receive(:add_index).exactly(4).times
    @call_back.should_receive(:add_foreign_key).exactly(3).times
    @filtered_schema_reader.evaluate
  end

end
#ActiveRecord::Schema.define(:version => 0)

EXAMPLE_SCHEMA = <<FILE
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "facilities", :force => true do |t|
    t.text    "name",      :null => false
    t.integer "warden_id", :null => false
  end

  add_index "facilities", ["warden_id"], :name => "warden_id", :unique => true

  create_table "prisoners", :force => true do |t|
    t.text    "name",        :null => false
    t.integer "facility_id", :null => false
  end

  add_index "prisoners", ["facility_id"], :name => "facility_id"

  create_table "wardens", :primary_key => "facility_id", :force => true do |t|
    t.integer "id",   :null => false
    t.text    "name", :null => false
  end

  add_index "wardens", ["facility_id"], :name => "facility_id", :unique => true
  add_index "wardens", ["id"], :name => "id"

  add_foreign_key "facilities", "wardens", :name => "facilities_warden_id"

  add_foreign_key "prisoners", "facilities", :name => "prisoners_facility_id"

  add_foreign_key "wardens", "facilities", :name => "wardens_facility_id"

end
FILE


