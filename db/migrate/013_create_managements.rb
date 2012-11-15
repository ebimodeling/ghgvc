class CreateManagements < ActiveRecord::Migration
  def self.up
    create_table :managements do |t|
      t.integer :citation_id
      t.date :date
      t.decimal :dateloc
      t.string :type
      t.decimal :level
      t.string :units
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :managements
  end
end
