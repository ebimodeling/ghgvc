class AlterCultivarsSpecie < ActiveRecord::Migration
  def self.up
    #remove_index :cultivars, :plant_id
    rename_column :cultivars, :plant_id, :specie_id
    #add index :cultivars, :specie_id
  end

  def self.down
    #remove_index :cultivars, :specie_id
    rename_column :cultivars, :specie_id, :plant_id
    #add index :cultivars, :plant_id
  end
end
