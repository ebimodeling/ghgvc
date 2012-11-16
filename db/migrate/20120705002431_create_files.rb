class CreateFiles < ActiveRecord::Migration
  def self.up

    create_table :files do |t|
      t.string :file_name
      t.string :file_path
      t.string :md5
      t.integer :created_user_id
      t.integer :updated_user_id
      t.references :machine
      t.references :format
    end

    create_table :containers_files, :id => false do |t|
      t.references :container, :polymorphic => true
      t.references :file
    end

    add_index :containers_files, :container_id, :unique => true
    add_index :containers_files, :container_type, :unique => true
    add_index :containers_files, :file_id, :unique => true

  end

  def self.down
    drop_table :files
    drop_table :containers_files
    
    remove_index :containers_files, :container_id
    remove_index :containers_files, :container_type
    remove_index :containers_files, :file_id
    
  end
end
