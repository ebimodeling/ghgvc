class AddFieldsToInputs < ActiveRecord::Migration
  def self.up
    add_column :inputs, :start_date, :datetime
    add_column :inputs, :end_date, :datetime
    add_column :inputs, :name, :string
  end

  def self.down
    remove_column :inputs, :start_date
    remove_column :inputs, :end_date
    remove_column :inputs, :name
  end
end
