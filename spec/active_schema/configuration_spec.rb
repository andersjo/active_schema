require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveSchema::Configuration do
  before(:each) do
    @configuration = ActiveSchema::Configuration.new
  end

  it "should have en empty array of foreign_keys" do
    @configuration.foreign_keys.should be_a_kind_of(Array)
    @configuration.foreign_keys.should be_empty
  end

  context "add_foreign_key" do
    it "should add an entry to foreign_keys " do
      expect {
        @configuration.add_foreign_key("from_table", "to_table", :column => "key_column")
      }.to change { @configuration.foreign_keys.size }.by(1)
    end
  end

  context "foreign_keys_from" do
    it "should select foreign keys originating in src table" do
      @configuration.add_foreign_key("crimes", "perpetrators", :column => "perpetrator_id")
      @configuration.add_foreign_key("perpetrators", "finger_prints", :column => "finger_print_id")
      @configuration.foreign_keys_from("crimes").size.should == 1
    end
  end

  context "foreign_keys_to" do
    it "should select foreign keys pointing to dst table" do
      @configuration.add_foreign_key("finger_prints", "perpetrators", :column => "perpetrator_id")
      @configuration.add_foreign_key("perpetrators", "finger_prints", :column => "finger_print_id")
      @configuration.foreign_keys_to("finger_prints").size.should == 1
    end
  end

end

