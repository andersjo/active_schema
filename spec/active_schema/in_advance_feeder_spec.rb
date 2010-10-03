require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include ActiveSchema

describe InAdvanceFeeder do
  before(:each) do
    @prisoner_model = prisoner_model
    @in_advance_feeder = InAdvanceFeeder.new
    @in_advance_feeder.stub!(:dispatch_attachments)
  end

  context "when a model is loaded" do
    after { @in_advance_feeder.model_loaded(@prisoner_model) }

    it "adds the model" do
      @in_advance_feeder.table_hub.should_receive(:add_model).with(@prisoner_model)
    end

    it "attaches associations and validations" do
      @in_advance_feeder.should_receive(:dispatch_attachments)
    end

  end

end

