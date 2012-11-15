class CreateLocationYields < ActiveRecord::Migration
  def self.up
    create_table :location_yields do |t|
      t.decimal :lat, :precision => 20, :scale => 15
      t.decimal :lon, :precision => 20, :scale => 15
      t.decimal :yield, :precision => 20, :scale => 15
      t.string :species

      t.timestamps
    end
  end

  def self.down
    drop_table :location_yields
  end
end
