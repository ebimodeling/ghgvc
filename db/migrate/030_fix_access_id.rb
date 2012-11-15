class FixAccessId < ActiveRecord::Migration
  def self.up
    remove_column :traits, :access_id
    add_column :traits, :user_id, :integer
    remove_column :yields, :access_id
    add_column :yields, :user_id, :integer

  end

  def self.down
    add_column :traits, :access_id, :integer
    remove_column :traits, :user_id
    add_column :yields, :access_id, :integer
    remove_column :yields, :user_id

  end
end
