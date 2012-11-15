class FirstStepInTraitDateChange < ActiveRecord::Migration
  def self.up
    add_column :traits, :date_year, :integer
    add_column :traits, :date_month, :integer
    add_column :traits, :date_day, :integer
  end

  def self.down
    remove_column :traits, :date_year
    remove_column :traits, :date_month
    remove_column :traits, :date_day
  end
end
