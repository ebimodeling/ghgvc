class AddEvenMoreIndexesToBety < ActiveRecord::Migration
  def self.up
    add_index :inputs, :site_id
    add_index :inputs, :format_id
    add_index :likelihoods, :run_id
    add_index :likelihoods, :variable_id
    add_index :likelihoods, :input_id
    add_index :models, :parent_id
    add_index :posteriors, :pft_id
    add_index :posteriors, :parent_id
    add_index :runs, :model_id
    add_index :runs, :site_id
#    remove_column :species, :plant_id
  end

  def self.down
    remove_index :inputs, :site_id
    remove_index :inputs, :format_id
    remove_index :likelihoods, :run_id
    remove_index :likelihoods, :variable_id
    remove_index :likelihoods, :input_id
    remove_index :models, :parent_id
    remove_index :posteriors, :pft_id
    remove_index :posteriors, :parent_id
    remove_index :runs, :model_id
    remove_index :runs, :site_id
#    add_column :species, :plant_id, :integer
  end
end
