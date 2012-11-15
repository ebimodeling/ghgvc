class AddAccessLevel < ActiveRecord::Migration
  def self.up
    add_column :yields, :access_level, :integer
    add_column :traits, :access_level, :integer
  end

  def self.down
    remove_column :cultivars, :previous_id
  end
end
