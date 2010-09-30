require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include ActiveSchema

describe InAdvanceFeeder do
  before(:each) do
    @prisoner_model = Prisoner.dup
    @table_hub = ActiveSchema::TableHub.new
    @dispatcher = mock("Dispatcher").as_null_object
    @in_advance_feeder = InAdvanceFeeder.new(@table_hub, @dispatcher)
    @in_advance_feeder.stub!(:dispatch_attachments)
    @in_advance_feeder.stub!(:add_model)

  end

  context "when a model is loaded" do
    after { @in_advance_feeder.model_loaded(@prisoner_model) }

    it "adds the model" do
      @in_advance_feeder.should_receive(:add_model).with(@prisoner_model)
    end

    it "attaches associations and validations" do
      @in_advance_feeder.should_receive(:dispatch_attachments)
    end

  end

end

