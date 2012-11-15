class AlterCultivarsSpecie < ActiveRecord::Migration
  def self.up
    rename_column :cultivars, :plant_id, :specie_id

  end

  def self.down
    rename_column :cultivars, :specie_id, :plant_id

  end
end
