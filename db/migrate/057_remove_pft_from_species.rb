class RemovePftFromSpecies < ActiveRecord::Migration
  def self.up
    remove_column :species, :pft
  end

  def self.down
    add_column :species, :pft, :integer
  end
end
