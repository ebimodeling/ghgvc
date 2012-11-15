class CreateManagementsTreatments < ActiveRecord::Migration
  def self.up
    create_table :managements_treatments, :id => false do |t|
      t.integer :treatment_id
      t.integer :management_id

      t.timestamps
    end

    add_index :managements_treatments, [ :management_id, :treatment_id ], :unique => true

  end


  def self.down
    drop_table :managements_treatments
  end
end
