class AddFormatIdToInputs < ActiveRecord::Migration
  def self.up
    add_column :inputs, :format_id, :integer
    add_index :inputs, :format_id
  end

  def self.down
    remove_column :inputs, :format_id
  end
end
