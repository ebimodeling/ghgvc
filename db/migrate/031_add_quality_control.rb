class AddQualityControl < ActiveRecord::Migration
  def self.up
    add_column :traits, :checked, :boolean, :default => 0
    add_column :yields, :checked, :boolean, :default => 0

  end

  def self.down
    remove_column :traits, :checked
    remove_column :yields, :checked

  end
end
