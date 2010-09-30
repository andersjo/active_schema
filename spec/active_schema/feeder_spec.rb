# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveSchema::Feeder do
  before(:each) do
    @table_hub = ActiveSchema::TableHub.new
    @feeder = ActiveSchema::Feeder.new(@table_hub)
    @feeder.stub_chain("associations_generator.new.generate")
    @feeder.stub_chain("validations_generator.new.generate")

    @prisoner_model = mock("PrisonerModel",
      :table_name => 'prisoners',
      :columns => [mock("Column1")]
    )
    @prisoner_table = ActiveSchema::Table.new("prisoners", @prisoner_model)
    @facility_table_without_model = ActiveSchema::Table.new("facilities")
  end

  context "when attaching validations" do
    after { @feeder.generate_validations(@prisoner_table) }
    it "should instantiate validation generator with table" do
      @feeder.validations_generator.should_receive(:new).with(@prisoner_table)
    end
  end

  context "when attaching associations" do
    context "and reference table is not resolved" do
      after do
#        @feeder.table_hub.add_foreign_key('')
#        @prisoner_table.add_foreign_key('facility_id', @facility_table_without_model)
#        @feeder.attach_associations(@prisoner_table)
      end

      it "should not instantiate associations generator" do
#        @feeder.associations_generator.should_not_receive(:new)
      end
    end

    context "and reference table is resolved" do
      after do
        @facility_table_without_model.model = mock("FacilityModel")
        @prisoner_table.add_foreign_key('facility_id', @facility_table_without_model)
        @feeder.generate_validations(@prisoner_table)
      end

      it "should instantiate associations generator" do
#        @feeder.associations_generator.should_receive(:new)
      end
    end

  end
end

