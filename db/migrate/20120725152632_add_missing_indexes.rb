class AddMissingIndexes < ActiveRecord::Migration
  def self.up
#    add_index :citations, :user_id
    
    add_column :dbfiles, :created_user_id, :integer
    add_index :dbfiles, :created_user_id

    add_column :dbfiles, :updated_user_id, :integer
    add_index :dbfiles, :updated_user_id
    
    add_column :dbfiles, :machine_id, :integer
    add_index :dbfiles, :machine_id

#    add_column :dbfiles, :format_id, :integer   
#    add_index :dbfiles, :format_id

#    add_column :dbfiles, :parent_id, :integer
    add_index :dbfiles, :parent_id

    add_column :dbfiles, :container_id, :integer
    add_index :dbfiles, :container_id
    
    add_column :dbfiles, :container_type, :integer
    add_index :dbfiles, :container_type

#    add_column :entities, :parent_id, :integer
    add_index :entities, :parent_id

#    add_column :formats_variables, [:format_id, :variable_id] , :integer
    add_index :formats_variables, [:format_id, :variable_id] 

#    add_column :inputs, :parent_id, :integer
    add_index :inputs, :parent_id

#    add_column :inputs, :user_id, :integer
    add_index :inputs, :user_id

#    add_column :machines, :hostname, :integer
    add_index :machines, :hostname

#    add_column :managements, :user_id, :integer
    add_index :managements, :user_id

#    add_column :methods, :citation_id, :integer
    add_index :methods, :citation_id

#    add_column :runs, :ensemble_id, :integer
    add_index :runs, :ensemble_id

#    add_column :sites, :user_id, :integer
    add_index :sites, :user_id

#    add_column :traits, :user_id, :integer
    add_index :traits, :user_id

#    add_column :traits, :entity_id, :integer
    add_index :traits, :entity_id

#    add_column :traits, :method_id, :integer
    add_index :traits, :method_id

#    add_column :treatments, :user_id, :integer 
    add_index :treatments, :user_id 

#    add_column :yields, :user_id, :integer
    add_index :yields, :user_id

#    add_column :yields, :method_id, :integer
    add_index :yields, :method_id
  end

  def self.down
#    remove_column :citations, :user_id
    
    remove_column :dbfiles, :created_user_id
    remove_column :dbfiles, :updated_user_id
    remove_column :dbfiles, :machine_id
    remove_column :dbfiles, :format_id
    remove_column :dbfiles, :parent_id
    remove_column :dbfiles, :container_id
    remove_column :dbfiles, :container_type
    remove_column :entities, :parent_id
    remove_column :formats_variables, [:format_id, :variable_id] 
    remove_column :inputs, :parent_id
    remove_column :inputs, :user_id
    remove_column :machines, :hostname
    remove_column :managements, :user_id
    remove_column :methods, :citation_id
    remove_column :runs, :ensemble_id
    remove_column :sites, :user_id
    remove_column :traits, :user_id
    remove_column :traits, :entity_id
    remove_column :traits, :method_id
    remove_column :treatments, :user_id 
    remove_column :yields, :user_id
    remove_column :yields, :method_id
  end
end
