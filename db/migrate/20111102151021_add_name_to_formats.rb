class AddNameToFormats < ActiveRecord::Migration
  def self.up
    add_column :formats, :name, :string
  end

  def self.down
    remove_column :formats, :name
  end
end
