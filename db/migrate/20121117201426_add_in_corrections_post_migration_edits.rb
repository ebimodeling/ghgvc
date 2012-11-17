class AddInCorrectionsPostMigrationEdits < ActiveRecord::Migration
  def self.up
    add_column :workflows, :site_id, :integer
    add_column :workflows, :model_id, :integer, :null => false
    add_column :workflows, :hostname, :string
    add_column :workflows, :params, :string
        
    rename_column :workflows, :started_at, :start_date
    rename_column :workflows, :finished_at, :end_date
    rename_column :workflows, :outdir, :folder
    
    add_column :models, :site_id, :integer
    add_column :models, :model_id, :integer
    add_column :models, :hostname, :string
    add_column :models, :start_date, :datetime
    add_column :models, :end_date, :datetime
    add_column :models, :params, :string
  end

  def self.down
    remove_column :workflows, :site_id
    remove_column :workflows, :model_id
    remove_column :workflows, :hostname
    remove_column :workflows, :params
        
    rename_column :workflows, :start_date, :started_at
    rename_column :workflows, :end_date, :finished_at
    rename_column :workflows, :folder, :outdir
  
    remove_column :models, :site_id
    remove_column :models, :model_id
    remove_column :models, :hostname
    remove_column :models, :start_date
    remove_column :models, :end_date
    remove_column :models, :params
  end
end
