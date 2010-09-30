require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ActiveSchema::Validations::ByColumn do
  after { described_class.new(@model, @column).generate }

  def given_column(name, sql_type, null = true)
    @model = double("FakeModel")
    @column = ActiveRecord::ConnectionAdapters::Column.new(name, nil, sql_type, null)
  end

  describe ActiveSchema::Validations::ByDataType do

    it "accepts only integers when int(11)" do
      given_column('digit', 'int(11)')
      @model.should_receive(:validates_numericality_of)\
        .with(:digit, {:allow_nil => true, :only_integer => true})
    end

    it "accepts only numbers when decimal(8,2)" do
      given_column('number', 'decimal(8,2)')
      @model.should_receive(:validates_numericality_of)\
        .with(:number, {:allow_nil => true})
    end

    it "validates text length when varchar(255)" do
      given_column('text', 'varchar(255)')
      @model.should_receive(:validates_length_of)\
        .with(:text, {:allow_nil => true, :maximum => 255})
    end
  end

  describe ActiveSchema::Validations::ByNullability do

    it "validates presence when varchar(255)" do
      given_column('text', 'varchar(255)', false)
      @model.should_receive(:validates_presence_of)\
        .with(:text, {})
    end

    it "validates inclusion of when boolean" do
      given_column('yes_or_no', 'boolean', false)
      @model.should_receive(:validates_inclusion_of)\
        .with(:yes_or_no, {:in => [true, false]})
    end
  end
end

