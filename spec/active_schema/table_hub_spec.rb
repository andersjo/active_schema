require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveSchema::TableHub do
  before(:each) do
    @table_hub = ActiveSchema::TableHub.new
  end

  def prisoner_model
    mock("PrisonerModel", :table_name => "prisoners")
  end

  def facility_model
    mock("FacilityModel", :table_name => "facilities")
  end

  context "when adding a model" do
    it "should have a table by the model's table name" do
      @table_hub.add_model(prisoner_model)
      @table_hub.tables.should have_key("prisoners")
    end

    context "and a table already exists" do
      it "should not change the identity of the existing table object" do
        @table_hub.add_model(prisoner_model)
        @table_hub.add_foreign_key('prisoners', 'facilities', 'facility_id') # Makes a Table object for the 'facilities' table
        facility_table = @table_hub.tables['facilities']
        @table_hub.add_model(facility_model)
        @table_hub.tables['facilities'].should equal(facility_table)
      end

      it "links the model with the existing table" do
        @table_hub.add_model(prisoner_model)
        @table_hub.add_foreign_key('prisoners', 'facilities', 'facility_id') # Makes a Table object for the 'facilities' table
        facility = facility_model
        @table_hub.add_model(facility)
        @table_hub.tables['facilities'].model.should == facility
      end
    end
  end

  context "when adding a foreign key" do
    it "should contain an entry for the destination table" do
      @table_hub.add_model(prisoner_model)
      @table_hub.add_foreign_key('prisoners', 'facilities', 'facility_id')
      @table_hub.tables.should have_key("facilities")
    end

    it "adds forward and reverse relations between tables" do
      @table_hub.add_foreign_key('prisoners', 'facilities', 'facility_id')
      @table_hub.relations['prisoners'].should include(@table_hub.tables['facilities'])
      @table_hub.relations['facilities'].should include(@table_hub.tables['prisoners'])
    end

    it "adds a foreign key to the source table" do
      @table_hub.add_model(prisoner_model)
      prisoner_table = @table_hub.tables['prisoners']
      prisoner_table.should_receive(:add_foreign_key)
      @table_hub.add_foreign_key('prisoners', 'facilities', 'facility_id')
    end

  end

  context "when adding an index" do
    it "should contain an entry for the indexed table" do
      @table_hub.add_index('prisoners', mock("IndexObject"))
      @table_hub.tables.should have_key("prisoners")
    end

    it "adds an index entry to the indexed table" do
      @table_hub.add_model(prisoner_model)
      index_obj = mock("IndexObject")
      @table_hub.tables['prisoners'].should_receive(:add_index).with(index_obj)
      @table_hub.add_index('prisoners', index_obj)
    end
  end

end

