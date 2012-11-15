class CreatePriors < ActiveRecord::Migration
  def self.up
    create_table :priors do |t|
      t.integer :citation_id
      t.string :variable_id
      t.string :phylogeny
      t.string :pft
      t.string :distn
      t.decimal :parama
      t.decimal :paramb
      t.decimal :paramc
      t.integer :n
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :priors
  end
end
