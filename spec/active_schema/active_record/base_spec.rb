require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'active_model/observing'

describe "Integration" do
  before do
    @base_class = Class.new()
    @base_class.send(:include, ActiveModel::Observing)
    @base_class.extend(ActiveSchema::ActiveRecord::ClassMethods)
    @base_class.send(:include, ActiveSchema::ActiveRecord::InstanceMethods)
    @feeder = mock("Feeder").as_null_object
    @base_class.active_schema_configuration.stub!(:feeder).and_return(@feeder)
  end

  it "responds to the active_schema method" do
    @base_class.should respond_to(:active_schema)
  end

  context "activation" do
    it "has a nil-valued class attribute active_schema_activated" do
      @base_class.should respond_to(:active_schema_activated)
      @base_class.active_schema_activated.should be_nil
    end

    it "should not bubble up the activation" do
      sub_class = Class.new(@base_class)
      sub_class.active_schema
      @base_class.active_schema_activated.should be_nil
    end

    it "inherits activation in subclasses" do
      sub_class = Class.new(@base_class)
      sub_class.active_schema
      below_sub_class = Class.new(sub_class)
      below_sub_class.active_schema_activated.should be_true
    end

    it "does not overwrite activation or deactivation in subclasses" do
      sub_class = Class.new(@base_class)
      below_sub_class = Class.new(sub_class)
      below_sub_class.active_schema_activated = false
      sub_class.active_schema
      below_sub_class.active_schema_activated.should be_false
    end

    it "allows independent subclass forks" do
      sub_class1 = Class.new(@base_class)
      sub_class2 = Class.new(@base_class)
      sub_class1.active_schema
      sub_class1.active_schema_activated.should be_true
      sub_class2.active_schema_activated.should be_false
    end
  end

  context "model loading" do
    before do
      @base_class.add_observer(ActiveRecord::ModelLoadedObserver.new)
    end

    it "loads model in directly activated class" do
      @feeder.should_receive(:model_loaded).with(instance_of(Class))
      sub_class = Class.new(@base_class)
      sub_class.active_schema
    end

    it "loads model in superclass activated class" do
      @feeder.should_receive(:model_loaded).with(instance_of(Class)).twice
      @base_class.active_schema
      sub_class = Class.new(@base_class)
    end
  end

  context "observers" do
    it "allows observers to be added" do
      @base_class.should respond_to(:add_observer)
    end

    it "should call observers when subclassed" do
      observer = mock("Observer")
      observer.should_receive(:update).with(:observed_class_inherited, instance_of(Class))
      @base_class.add_observer(observer)
      Class.new(@base_class)
    end
  end
end


describe ActiveRecord::Base do
  before do
    @prisoner_model = prisoner_model
    @facility_model = facility_model
  end

  it "should have the active_schema method" do
    described_class.should respond_to(:active_schema)
  end

  it "should have a correct Configuration object attached" do
    @prisoner_model.active_schema_configuration.should be_instance_of(ActiveSchema::Configuration)
    @prisoner_model.active_schema_configuration.feeder.should be_instance_of(ActiveSchema::OnTheFlyFeeder)
  end

  it "should activate model" do
    @prisoner_model.active_schema
    @prisoner_model.active_schema_activated.should be_true
  end

  it "adds (some) validations" do
    @prisoner_model.active_schema
    @prisoner_model.validators_on(:name).should_not be_empty
  end

  it "adds (some) assocations" do
    @prisoner_model.active_schema
    @facility_model.active_schema
    @prisoner_model.new.should respond_to(:facility)
  end
end
