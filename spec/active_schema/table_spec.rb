# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveSchema::Table do
  describe "unique_index_on?" do
    it "should be true if unique index" do
      Warden.table_with_indexes.unique_index_on?('facility_id').should be_true
    end
  end
end

