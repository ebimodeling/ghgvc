class RemoveFormatIdFromDbfiles < ActiveRecord::Migration
  def self.up

    remove_column :dbfiles, :format_id

  end

  def self.down
    add_column :dbfiles, :format_id, :integer
    add_index :dbfiles, :format_id
  end
end
