# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveSchema::OnTheFlyFeeder do
  before(:each) do
    @connection = mock("Connection")
    @prisoner_model = mock("PrisonerModel", 
      :table_name => 'prisoners',
      :connection => @connection
    )
    @prisoner_table = mock("PrisonerTable")
    @table_hub = ActiveSchema::TableHub.new
    @dispatcher = mock("Dispatcher").as_null_object
    @on_the_fly_attacher = ActiveSchema::OnTheFlyFeeder.new(@table_hub, @dispatcher)
    @on_the_fly_attacher.stub!(:dispatch_attachments)
  end

  context "when a model is loaded" do
    before {
      @index = mock("Index")
      @connection.stub(:indexes).and_return([@index])
      @fk = mock("ForeignKey",
        :from_table => 'prisoners',
        :to_table   => 'facilities',
        :options    => { :column => 'facility_id' }
      )
      @connection.stub(:foreign_keys).and_return([@fk])
    }
    after { @on_the_fly_attacher.model_loaded(@prisoner_model) }

    it "adds indexes to TableHub" do
      @connection.should_receive(:indexes).with(@prisoner_model.table_name)
      @table_hub.should_receive(:add_index).with(@prisoner_model.table_name, @index)
    end

    it "adds foreign keys to TableHub" do
      @connection.should_receive(:foreign_keys).with(@prisoner_model.table_name)
      @table_hub.should_receive(:add_foreign_key).with('prisoners', 'facilities', 'facility_id')
    end

    it "adds model to TableHub" do
      @table_hub.should_receive(:add_model).with(@prisoner_model)
    end

    it "attaches associations and validations" do
      @on_the_fly_attacher.should_receive(:dispatch_attachments)
    end
  end
end
