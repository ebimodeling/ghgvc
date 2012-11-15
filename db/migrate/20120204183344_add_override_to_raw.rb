class AddOverrideToRaw < ActiveRecord::Migration
  def self.up
    add_column :raws, :filepath_override, :boolean
  end

  def self.down
    remove_column :raws, :filepath_override
  end
end
