class ChangeDatumToEspg < ActiveRecord::Migration
  def self.up
    rename_column :sites, :datum, :espg
  end

  def self.down
    rename_column :sites, :espg, :datum
  end
end
