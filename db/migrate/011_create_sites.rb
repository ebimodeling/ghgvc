class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :usgsmuid
      t.string :city
      t.string :state
      t.string :country
      t.decimal :lat
      t.decimal :lon
      t.integer :gdd
      t.date :firstkillingfrost
      t.integer :mat
      t.integer :map
      t.integer :masl
      t.string :soil
      t.decimal :zrt
      t.decimal :zh2o
      t.decimal :som
      t.text :notes
      t.text :soilnotes

      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
