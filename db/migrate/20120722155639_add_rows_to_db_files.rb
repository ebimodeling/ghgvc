class AddRowsToDbFiles < ActiveRecord::Migration
  def self.up
    create_table :dbfiles do |t|
      t.integer :parent
    end
    
#    remove_column :dbfiles, :file_id
#    remove_column :inputs, :file_id
  end

  def self.down
    drop_table :dbfiles
    
    #add_column :dbfiles, :file_id, :integer
#    add_column :inputs, :file_id, :integer
  end
end
