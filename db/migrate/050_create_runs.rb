class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table :runs do |t|
      t.references :model
      t.references :site
      t.datetime :start_time
      t.datetime :finish_time
      t.string :outdir
      t.string :outprefix
      t.string :setting
      t.text :parameter_list

      t.timestamps
    end
  end

  def self.down
    drop_table :runs
  end
end
