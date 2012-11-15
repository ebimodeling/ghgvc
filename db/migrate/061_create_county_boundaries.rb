class CreateCountyBoundaries < ActiveRecord::Migration
  def self.up
    create_table :county_boundaries do |t|
      t.references :county
      t.decimal :lat, :precision => 20, :scale => 15
      t.decimal :lng, :precision => 20, :scale => 15
      t.integer :censusid

      t.timestamps
    end
  end

  def self.down
    drop_table :county_boundaries
  end
end
