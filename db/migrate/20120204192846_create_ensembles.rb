class CreateEnsembles < ActiveRecord::Migration
  def self.up
    create_table :ensembles do |t|
      t.text :notes

      t.timestamps
    end

    add_column :raws, :ensemble_id, :integer
  end

  def self.down
    drop_table :ensembles
    remove_column :raws, :ensemble_id
  end
end
