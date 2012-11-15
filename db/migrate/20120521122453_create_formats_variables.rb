class CreateFormatsVariables < ActiveRecord::Migration
  def self.up
    create_table :formats_variables do |t|
      t.references :format
      t.references :variable
      t.string :name
      t.string :unit
      t.string :storage_type
      t.integer :column_number

      t.timestamps
    end

    add_column :formats, :header, :string
    add_column :formats, :skip, :string
  end

  def self.down
    drop_table :formats_variables
    remove_column :formats, :header
    remove_column :formats, :skip
  end
end
