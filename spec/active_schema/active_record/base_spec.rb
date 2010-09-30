require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ActiveRecord::Base do
  it "should have the active_schema method" do
    described_class.should respond_to(:active_schema)
  end

  describe "active_schema activated" do
    context "when triggered in model" do
      before {
        Object.send(:remove_const, :Prisoner)
        class Prisoner < ActiveRecord::Base; end 
        Prisoner.active_schema
      }
      it "should initialize active_schema on Base" do
        ActiveRecord::Base.active_schema_feeder.should\
          be_kind_of(ActiveSchema::OnTheFlyFeeder)
      end
    end


#    context "when triggered on Base" do
#      before { ActiveRecord::Base.active_schema }
#      it "should initialize active_schema on Base" do
#        # FIXME: test is broken
#        ActiveRecord::Base.active_schema_feeder.should\
#          be_kind_of(ActiveSchema::OnTheFlyFeeder)
#      end
#
#      it "propagates to inherited models" do
#        Prisoner.active_schema_activated?.should be_true
#      end
#    end

    it "adds (some) validations" do
      Prisoner.active_schema
      Prisoner.validators_on(:name).should_not be_empty
    end

    it "adds (some) assocations" do
      Prisoner.active_schema
      Facility.active_schema
      Prisoner.new.should respond_to(:facility)
    end
  end
end

