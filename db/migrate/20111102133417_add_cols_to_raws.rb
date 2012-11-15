class AddColsToRaws < ActiveRecord::Migration
  def self.up
    add_column :raws, :user_id, :integer
    add_column :raws, :access_level, :integer
  end

  def self.down
    remove_column :raws, :user_id
    remove_column :raws, :access_level
  end
end
