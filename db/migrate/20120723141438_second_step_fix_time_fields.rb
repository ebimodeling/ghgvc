class SecondStepFixTimeFields < ActiveRecord::Migration
  def self.up
    add_column :traits, :time_hour, :integer
    add_column :traits, :time_minute, :integer
  end

  def self.down
    remove_column :traits, :time_hour
    remove_column :traits, :time_minute
  end
end
