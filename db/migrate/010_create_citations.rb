class CreateCitations < ActiveRecord::Migration
  def self.up
    create_table :citations do |t|
      t.string :author
      t.integer :year
      t.string :title
      t.string :journal
      t.integer :vol
      t.string :pg
      t.string :url
      t.string :pdf

      t.timestamps
    end
  end

  def self.down
    drop_table :citations
  end
end
