class AddPrecisionToSpecies < ActiveRecord::Migration
  def self.up
    change_column :species, :pH_Minimum, :decimal, :precision => 5, :scale => 2
    change_column :species, :pH_Maximum, :decimal, :precision => 5, :scale => 2
  end

  def self.down
  end
end
