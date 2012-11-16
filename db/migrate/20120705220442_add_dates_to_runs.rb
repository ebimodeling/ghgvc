class AddDatesToRuns < ActiveRecord::Migration
  def self.up

    add_column :runs, :start_date, :datetime
    add_column :runs, :end_date, :datetime

  end

  def self.down
    remove_column :runs, :start_date
    remove_column :runs, :end_date
  end
end
