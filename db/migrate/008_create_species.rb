class CreateSpecies < ActiveRecord::Migration
  def self.up
    create_table :species do |t|
      t.integer :spcd
      t.integer :pft
      t.string :genus
      t.string :species
      t.string :scientificname
      t.string :commonname

      t.timestamps
    end
  end

  def self.down
    drop_table :species
  end
end
