class RemoveRawTables < ActiveRecord::Migration
  def self.up

    drop_table :raws
    drop_table :raws_documents

  end

  def self.down
  
    create_table :raws
    create_table :raws_documents
  
  end
end
