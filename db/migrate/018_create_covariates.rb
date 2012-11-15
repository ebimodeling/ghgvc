class CreateCovariates < ActiveRecord::Migration
  def self.up
    create_table :covariates do |t|
      t.integer :trait_id
      t.integer :variable_id
      t.decimal :level

      t.timestamps
    end
  end

  def self.down
    drop_table :covariates
  end
end
