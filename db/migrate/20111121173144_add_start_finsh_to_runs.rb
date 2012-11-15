class AddStartFinshToRuns < ActiveRecord::Migration
  def self.up
    add_column :runs, :started_at, :datetime
    add_column :runs, :finished_at, :datetime
  end

  def self.down
    remove_column :runs, :started_at
    remove_column :runs, :finished_at
  end
end
