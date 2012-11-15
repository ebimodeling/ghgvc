class AddCitationDoi < ActiveRecord::Migration
  def self.up
    add_column :citations, :doi, :string
  end

  def self.down
    remove_column :citations, :doi
  end
end
