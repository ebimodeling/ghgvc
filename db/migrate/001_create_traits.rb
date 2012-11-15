class CreateTraits < ActiveRecord::Migration
  def self.up
    create_table :traits do |t|
      t.integer :site_id
      t.integer :specie_id
      t.integer :citation_id
      t.integer :cultivar_id
      t.integer :treatment_id
      t.integer :access_id
      t.integer :variable_id
      t.datetime :date
      t.decimal :dateloc
      t.time :time
      t.decimal :timeloc
      t.decimal :mean
      t.integer :n
      t.string :statname
      t.decimal :stat
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :traits
  end
end
