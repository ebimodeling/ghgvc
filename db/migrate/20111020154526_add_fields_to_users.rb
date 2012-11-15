class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state_prov, :string
    add_column :users, :postal_code, :string
  end

  def self.down
    remove_column :users, :state_prov
    remove_column :users, :postal_code
  end
end
