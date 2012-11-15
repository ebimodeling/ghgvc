class CreateInputs < ActiveRecord::Migration
  def self.up
    create_table :inputs do |t|
      t.references :site
      t.references :variable
      t.string :filepath
      t.text :format
      t.string :original_data
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :inputs
  end
end
