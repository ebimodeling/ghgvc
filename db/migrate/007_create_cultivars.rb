class CreateCultivars < ActiveRecord::Migration
  def self.up
    create_table :cultivars do |t|
      t.integer :plant_id
      t.string :name
      t.string :ecotype
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :cultivars
  end
end
