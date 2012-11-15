class RemoveFieldsFromSites < ActiveRecord::Migration
  def self.up
    remove_column :sites, :gdd
    remove_column :sites, :firstkillingfrost
    remove_column :sites, :zrt
    remove_column :sites, :zh2o
  end

  def self.down
    add_column :sites, :zh2o, :decimal
    add_column :sites, :zrt, :decimal
    add_column :sites, :firstkillingfrost, :date
    add_column :sites, :gdd, :integer
  end
end
