class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :citations, :user_id
    add_index :dbfiles, :created_user_id
    add_index :dbfiles, :updated_user_id
    add_index :dbfiles, :machine_id
    add_index :dbfiles, :format_id
    add_index :dbfiles, :parent_id
    add_index :dbfiles, [:container_id,:container_type]
    add_index :entities, :parent_id
    add_index :formats_variables, [:format_id, :variable_id] 
    add_index :inputs, :parent_id
    add_index :inputs, :user_id
    add_index :machines, :hostname
    add_index :managements, :user_id
    add_index :methods, :citation_id
    add_index :runs, :ensemble_id
    add_index :sites, :user_id
    add_index :traits, :user_id
    add_index :traits, :entity_id
    add_index :traits, :method_id
    add_index :treatments, :user_id 
    add_index :yields, :user_id
    add_index :yields, :method_id
  end

  def self.down
    remove_index :citations, :user_id
    remove_index :dbfiles, :created_user_id
    remove_index :dbfiles, :updated_user_id
    remove_index :dbfiles, :machine_id
    remove_index :dbfiles, :format_id
    remove_index :dbfiles, :parent_id
    remove_index :dbfiles, [:container_id,:container_type]
    remove_index :entities, :parent_id
    remove_index :formats_variables, [:format_id, :variable_id] 
    remove_index :inputs, :parent_id
    remove_index :inputs, :user_id
    remove_index :machines, :hostname
    remove_index :managements, :user_id
    remove_index :methods, :citation_id
    remove_index :runs, :ensemble_id
    remove_index :sites, :user_id
    remove_index :traits, :user_id
    remove_index :traits, :entity_id
    remove_index :traits, :method_id
    remove_index :treatments, :user_id 
    remove_index :yields, :user_id
    remove_index :yields, :method_id
  end
end
