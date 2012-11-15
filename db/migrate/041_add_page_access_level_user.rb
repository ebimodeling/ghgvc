class AddPageAccessLevelUser < ActiveRecord::Migration
  def self.up
    add_column :users, :page_access_level, :integer
  end

  def self.down
    remove_column :users, :page_access_level
  end
end
