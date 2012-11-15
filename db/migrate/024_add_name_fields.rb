class AddNameFields < ActiveRecord::Migration
  def self.up
    add_column :pfts, :name, :string
    add_column :variables, :name, :string
    rename_column :managements, :type, :mgmttype

  end

  def self.down
    remove_column :pfts, :name
    remove_column :variables, :name
    rename_column :managements, :mgmttype, :type

  end
end
