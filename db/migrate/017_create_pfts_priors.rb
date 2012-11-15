class CreatePftsPriors < ActiveRecord::Migration
  def self.up
    create_table :pfts_priors, :id => false do |t|
      t.integer :pft_id
      t.integer :prior_id

      t.timestamps
    end

    add_index :pfts_priors, [ :pft_id, :prior_id ], :unique => true

  end

  def self.down
    drop_table :pfts_priors
  end
end
