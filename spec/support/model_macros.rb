# To change this template, choose Tools | Templates
# and open the template in the editor.

module ModelMacros
  def self.included(cls)
    ['prisoners', 'facilities', 'wardens'].each do |table_name|
      method_def = <<CODE
def #{table_name.singularize}_model
  model_for("#{table_name}")
end

def #{table_name.singularize}_table
  table_for("#{table_name}")
end
CODE
      cls.class_eval(method_def)
    end
  end

  def model_for(table_name)
    new_model = Class.new(ActiveRecord::Base)
    new_model.set_table_name table_name
    new_model.stub!(:name).and_return(table_name.singularize.camelize)
    new_model
  end

  def table_for(table_name)
    ActiveSchema::Table.new(table_name, model_for(table_name))
  end

end
