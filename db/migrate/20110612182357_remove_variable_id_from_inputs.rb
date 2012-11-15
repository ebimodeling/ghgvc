class RemoveVariableIdFromInputs < ActiveRecord::Migration
  def self.up
    remove_column :inputs, :variable_id
    remove_column :inputs, :format
    add_column :inputs, :format_id, :integer
  end

  def self.down
    add_column :inputs, :variable_id, :integer
    add_column :inputs, :variable_id, :text
    remove_column :inputs, :format_id
  end
end
