class AddTreatmentsControl < ActiveRecord::Migration
  def self.up
    add_column :treatments, :control, :boolean

  end

  def self.down
    remove_column :treatments, :control

  end
end
