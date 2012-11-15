class CreateMoreIndex < ActiveRecord::Migration
  def self.up
    add_index :error_logs, :user_id
  end

  def self.down
    remove_index :error_logs, :user_id
  end
end
