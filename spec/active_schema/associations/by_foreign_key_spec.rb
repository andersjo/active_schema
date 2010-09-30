require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
include ActiveSchema::Associations

describe ActiveSchema::Associations::ByForeignKey do
  def given_foreign_key(from_table, to_table, key_name, unique = false)
    @from_model = mock("FakeFromModel",
      :columns => [ActiveRecord::ConnectionAdapters::Column.new(key_name, nil, 'int(11)')],
      :name => from_table.singularize.camelize
    )
    @to_model = mock("FakeToModel",
      :name => to_table.singularize.camelize
    )
    @key_name = key_name
    @unique = unique
  end
  after {
    described_class.new(@from_model, @to_model, @key_name, @unique).generate
  }
  
  describe ActiveSchema::Associations::ByForwardForeignKey do 
    it "sets belongs_to" do
      given_foreign_key('prisoners', 'facilities', 'facility_id')
      @from_model.should_receive(:belongs_to)\
        .with("facility", { :class_name => "Facility", :foreign_key => 'facility_id'})
    end
  end

  describe ActiveSchema::Associations::ByReverseForeignKey do
    context "Key column not unique" do
      it "sets has_many" do
        given_foreign_key('prisoners', 'facilities', 'facility_id')
        @to_model.should_receive(:has_many)\
          .with("prisoners", { :class_name => "Prisoner", :foreign_key => 'facility_id'})
      end
    end
    context "Key column unique" do
      it "sets has_one" do
        given_foreign_key('prisoners', 'facilities', 'facility_id', true)
        @to_model.should_receive(:has_one)\
          .with("prisoner", { :class_name => "Prisoner", :foreign_key => 'facility_id'})
      end

    end
  end
end

describe ActiveSchema::Associations::Naming do
  before {
    @naming = Class.new.send(:include, Naming).new
  }

  def given_model(model_name)
    @model = mock(model_name, :name => model_name)
  end
  context "name_for" do
    it "underscores camelized names" do
      given_model("ABumpyBackModel")
      @naming.name_for(@model).should == "a_bumpy_back_model"
    end

    it "strips module names" do
      given_model("Hideously::Complicated::And::Convoluted::ClassHierarchy")
      @naming.name_for(@model).should == "class_hierarchy"
    end
  end

  context "plural_name_for" do
    it "pluralizes name_for" do
      given_model("BumpyBackModel")
      @naming.plural_name_for(@model).should == "bumpy_back_models"
    end
  end
end