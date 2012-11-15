class CreateCitationsTreatments < ActiveRecord::Migration
  def self.up
    create_table :citations_treatments, :id => false do |t|
      t.integer :citation_id
      t.integer :treatment_id

      t.timestamps
    end

    add_index :citations_treatments, [ :citation_id, :treatment_id ], :unique => true

  end

  def self.down
    drop_table :citations_treatments
  end
end
