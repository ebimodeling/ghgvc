class CreateMethods < ActiveRecord::Migration
  def self.up
    create_table :methods do |t|
      t.string :name
      t.text :description
      t.references :citation

      t.timestamps
    end

    add_column :traits, :method_id, :integer
    add_column :yields, :method_id, :integer
  end

  def self.down
    drop_table :methods
    add_column :traits, :method_id
    add_column :yields, :method_id
  end
end
