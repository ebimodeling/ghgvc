class CreatePftsSpecies < ActiveRecord::Migration
  def self.up
    create_table :pfts_species, :id => false do |t|
      t.integer :pft_id
      t.integer :specie_id

      t.timestamps
    end

    add_index :pfts_species, [ :pft_id, :specie_id ], :unique => true

  end


  def self.down
    drop_table :pfts_species
  end
end
