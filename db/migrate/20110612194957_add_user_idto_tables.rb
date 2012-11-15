class AddUserIdtoTables < ActiveRecord::Migration
  def self.up
    add_column :citations, :user_id, :integer
    add_column :managements, :user_id, :integer
    add_column :sites, :user_id, :integer
    add_column :treatments, :user_id, :integer
  end

  def self.down
    remove_column :citations, :user_id
    remove_column :managements, :user_id
    remove_column :sites, :user_id
    remove_column :treatments, :user_id
  end
end
