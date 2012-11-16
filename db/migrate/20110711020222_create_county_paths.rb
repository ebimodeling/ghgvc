class CreateCountyPaths < ActiveRecord::Migration
  def self.up
    create_table :county_paths do |t|
      t.integer :county_id
      t.integer :zoom
      t.text :path

      t.timestamps
    end

    add_index :county_paths, [:county_id, :zoom]
    add_index :county_paths, :county_id
  end

  def self.down
    drop_table :county_paths
    remove_index :county_paths, [:county_id, :zoom]
    remove_index :county_paths, :county_id
  end
end
