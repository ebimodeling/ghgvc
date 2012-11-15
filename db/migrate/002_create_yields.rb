class CreateYields < ActiveRecord::Migration
  def self.up
    create_table :yields do |t|
      t.integer :citation_id
      t.integer :site_id
      t.integer :specie_id
      t.integer :treatment_id
      t.integer :cultivar_id
      t.integer :access_id
      t.date :date
      t.decimal :dateloc
      t.string  :statname
      t.decimal :stat
      t.decimal :mean
      t.integer :n
      t.text    :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :yields
  end
end
