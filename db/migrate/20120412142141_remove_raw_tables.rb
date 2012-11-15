class RemoveRawTables < ActiveRecord::Migration
  def self.up

    drop_table :raws
    drop_table :raws_documents

  end

  def self.down
  end
end
