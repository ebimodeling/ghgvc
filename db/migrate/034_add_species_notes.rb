class AddSpeciesNotes < ActiveRecord::Migration
  def self.up
    add_column :species, :notes, :text
  end

  def self.down
    remove_column :species, :notes
  end
end
