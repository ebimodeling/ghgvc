class CreateVariables < ActiveRecord::Migration
  def self.up
    create_table :variables do |t|
      t.string :description
      t.string :units
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :variables
  end
end
