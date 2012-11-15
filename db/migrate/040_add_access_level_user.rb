class AddAccessLevelUser < ActiveRecord::Migration
  def self.up
    add_column :users, :access_level, :integer
  end

  def self.down
    remove_column :users, :access_level
  end
end
