class CreatePosteriors < ActiveRecord::Migration
  def self.up
    create_table :posteriors do |t|
      t.integer :pft_id
      t.string :filename
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :posteriors
  end
end
