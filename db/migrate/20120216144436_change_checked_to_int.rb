class ChangeCheckedToInt < ActiveRecord::Migration
  def self.up
    change_column :traits, :checked, :integer
    change_column :yields, :checked, :integer

    remove_column :raws, :ensemble_id

    add_column :runs, :ensemble_id, :integer

  end

  def self.down

    change_column :traits, :checked, :boolean
    change_column :yields, :checked, :boolean

    remove_column :runs, :ensemble_id

    add_column :raws, :ensemble_id, :integer
  end
end
