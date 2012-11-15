class FixDatesInRuns < ActiveRecord::Migration
  def self.up
    change_column :runs, :start_date, :string
    change_column :runs, :end_date, :string
  end

  def self.down
    change_column :runs, :start_date, :datetime
    change_column :runs, :end_date, :datetime
  end
end
