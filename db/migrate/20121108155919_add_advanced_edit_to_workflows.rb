class AddAdvancedEditToWorkflows < ActiveRecord::Migration
  def self.up
    add_column :workflows, :advanced_edit, :boolean, :default => false
  end

  def self.down
    remove_column :workflows, :advanced_edit
  end
end
