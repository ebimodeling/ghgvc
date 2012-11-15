class AddIndexToLocationYields < ActiveRecord::Migration
  def self.up

    add_index :location_yields, :yield

  end

  def self.down

    remove_index :location_yields, :yield

  end
end
