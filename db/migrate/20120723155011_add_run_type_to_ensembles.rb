class AddRunTypeToEnsembles < ActiveRecord::Migration
  def self.up
    add_column :ensembles, :runtype, :string
  end

  def self.down
    remove_column :ensembles, :runtype
  end
end
