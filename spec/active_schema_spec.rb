require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActiveSchema" do
  context "configuration" do
    it "has configuration method" do
      ActiveSchema.should respond_to :configuration
    end
    
    it "defaults to OnTheFlyFeeder" do 
      ActiveSchema.configuration.feeder.should be_instance_of(ActiveSchema::OnTheFlyFeeder)
    end
  end

end
