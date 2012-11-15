class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.integer :parent_id
      t.string :name
      t.text :notes

      t.timestamps
    end
    add_column :traits, :entity_id, :integer
  end

  def self.down
    drop_table :entities
    remove_column :traits, :entity_id
  end
end
