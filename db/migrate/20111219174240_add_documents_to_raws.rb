class AddDocumentsToRaws < ActiveRecord::Migration
  def self.up
    create_table :raws_documents do |t|
      t.integer  "raw_id"
      t.string   "updated_by"
      t.string   "doc_file_name"
      t.string   "doc_content_type"
      t.integer  "doc_file_size"
      t.datetime "doc_created_at"
      t.datetime "doc_updated_at"
      t.timestamps
    end
  end

  def self.down
    drop_table :raws_documents

  end
end
