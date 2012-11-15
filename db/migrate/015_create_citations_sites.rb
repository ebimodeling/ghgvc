class CreateCitationsSites < ActiveRecord::Migration
  def self.up
    create_table :citations_sites, :id => false do |t|
      t.integer :citation_id
      t.integer :site_id

      t.timestamps
    end

    add_index :citations_sites, [ :citation_id, :site_id ], :unique => true
 
  end


  def self.down
    drop_table :citations_sites
  end
end
