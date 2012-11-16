class DropErrorLogsTable < ActiveRecord::Migration
  def self.up
    drop_table :error_logs
  end

  def self.down
    create_table :error_logs
  end
end
