require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveSchema::AttachmentDispatcher do
  before(:each) do
    @attachment_dispatcher = ActiveSchema::AttachmentDispatcher.new
    @attachment_dispatcher.associations_generator = mock("AssociationsGen")
    @attachment_dispatcher.associations_generator.stub_chain("new.generate")
    @attachment_dispatcher.validations_generator = mock("ValidationsGen")
    @attachment_dispatcher.validations_generator.stub_chain("new.generate")

    @prisoner_model = mock("PrisonerModel",
      :table => 'prisoners',
      :columns => [mock("Column1")]
    )
    @prisoner_table = ActiveSchema::Table.new("prisoners", @prisoner_model)
    @facility_table_without_model = ActiveSchema::Table.new("facilities")
  end

  context "when attaching validations" do
    after { @attachment_dispatcher.attach_validations(@prisoner_table) }
    it "should instantiate validation generator with table" do
      @attachment_dispatcher.validations_generator.should_receive(:new).with(@prisoner_table)
    end
  end

  context "when attaching associations" do
    after { @attachment_dispatcher.attach_associations(@prisoner_table) }
    context "and reference table is not resolved" do
      it "should not instantiate associations generator" do
        @prisoner_table.add_foreign_key('facility_id', @facility_table_without_model)
        @attachment_dispatcher.associations_generator.should_not_receive(:new)
      end
    end
    context "and reference table is resolved" do
      it "should instantiate associations generator" do
        @prisoner_table.add_foreign_key('facility_id', @facility_table_without_model)
        @facility_table_without_model.model = mock("FacilityModel")
        @attachment_dispatcher.associations_generator.should_receive(:new)
      end
    end

  end

end

