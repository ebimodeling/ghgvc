class AddStateToCounty < ActiveRecord::Migration
  def self.up
    add_column :counties, :state, :string
  end

  def self.down
    remove_column :counties, :state
  end
end
