require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ActiveSchema::Validations::Generator do
  before {
    @prisoner_table = prisoner_table
    @prisoner_model = @prisoner_table.model
  }

  it "is a healthy model" do
    @prisoner_model.columns.should_not be_nil
  end

  it "skips validation for columns in given proc" do
    @prisoner_model.should_not be_nil
    skip_proc = proc{|column| column.name == "id" }
    generator = ActiveSchema::Validations::Generator.new(@prisoner_table, skip_proc)
    generator.generate
    @prisoner_model.validators_on(:id).should be_empty
    @prisoner_model.validators_on(:name).should_not be_empty

  end
end

