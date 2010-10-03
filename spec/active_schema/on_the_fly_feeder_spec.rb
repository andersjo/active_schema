# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveSchema::OnTheFlyFeeder do
  before(:each) do
    @on_the_fly_feeder = ActiveSchema::OnTheFlyFeeder.new
    @prisoner_model = prisoner_model
    @table_hub = @on_the_fly_feeder.table_hub
  end

  context "when a model is loaded" do
    after { @on_the_fly_feeder.model_loaded(@prisoner_model) }

    it "adds indexes to TableHub" do
      @table_hub.should_receive(:add_index)\
        .with(@prisoner_model.table_name, instance_of(ActiveRecord::ConnectionAdapters::IndexDefinition))
    end

    it "adds foreign keys to TableHub" do
      @table_hub.should_receive(:add_foreign_key).with('prisoners', 'facilities', 'facility_id')
    end
    #
    it "adds model to TableHub" do
      @on_the_fly_feeder.stub!(:dispatch_attachments)
      @table_hub.should_receive(:add_model).with(@prisoner_model)
    end

    it "attaches associations and validations" do
      @on_the_fly_feeder.should_receive(:dispatch_attachments)
    end
  end
end
