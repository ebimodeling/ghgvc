class CreateFormats < ActiveRecord::Migration
  def self.up
    create_table :formats do |t|
      t.string :mime_type
      t.text :schema
      t.text :notes

      t.timestamps
    end

    add_index :formats, :mime_type
  end

  def self.down
    drop_table :formats
    remove_index :formats, :mime_type
  end
end
