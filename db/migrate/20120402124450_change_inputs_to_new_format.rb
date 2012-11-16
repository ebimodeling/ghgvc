class ChangeInputsToNewFormat < ActiveRecord::Migration
  def self.up
    add_column :inputs, :parent_id, :integer 
    add_column :inputs, :user_id, :integer
    add_column :inputs, :access_level, :integer
    add_column :inputs, :raw, :boolean

    remove_column :inputs, :raw_id
    remove_column :inputs, :format_id
    remove_column :inputs, :filepath

    create_table :input_files do |t|
      t.integer :file_id
      t.integer :format_id
      t.string :file_name
      t.string :file_path
      t.integer :machine_id
      t.string :md5
      t.integer :created_user_id
      t.integer :updated_user_id

      t.timestamps
    end

  end

  def self.down
    remove_column :inputs, :parent_id
    remove_column :inputs, :user_id
    remove_column :inputs, :access_level
    remove_column :inputs, :raw

    add_column :inputs, :raw_id, :integer
    add_column :inputs, :format_id, :integer
    ass_column :inputs, :filepath, :string

    drop_table :input_files

  end
end
