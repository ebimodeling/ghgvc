class CreateErrors < ActiveRecord::Migration
  def self.up
    create_table :error_logs do |t|
      t.integer :record_id
      t.string :description
      t.string :relationship
      t.integer :user_id
      t.integer :fixed

      t.timestamps
    end
  end

  def self.down
    drop_table :error_logs
  end
end
