class FixDecimals < ActiveRecord::Migration
  def self.up
    change_column :sites, :lat, :decimal, :precision => 9, :scale => 6
    change_column :sites, :lon, :decimal, :precision => 9, :scale => 6
    change_column :sites, :zrt, :decimal, :precision => 4, :scale => 2
    change_column :sites, :zh2o, :decimal, :precision => 4, :scale => 1
    change_column :sites, :som, :decimal, :precision => 4, :scale => 2

    change_column :yields, :dateloc, :decimal, :precision => 4, :scale => 2
    change_column :yields, :mean, :decimal, :precision => 16, :scale => 4
    change_column :yields, :stat, :decimal, :precision => 16, :scale => 4

    change_column :traits, :dateloc, :decimal, :precision => 4, :scale => 2
    change_column :traits, :timeloc, :decimal, :precision => 4, :scale => 2
    change_column :traits, :mean, :decimal, :precision => 16, :scale => 4
    change_column :traits, :stat, :decimal, :precision => 16, :scale => 4

    change_column :priors, :parama, :decimal, :precision => 16, :scale => 4
    change_column :priors, :paramb, :decimal, :precision => 16, :scale => 4
    change_column :priors, :paramc, :decimal, :precision => 16, :scale => 4

    change_column :covariates, :level, :decimal, :precision => 16, :scale => 4

    change_column :managements, :dateloc, :decimal, :precision => 4, :scale => 2
    change_column :managements, :level, :decimal, :precision => 16, :scale => 4

    change_column :plants, :pH_Minimum, :decimal, :precision => 5, :scale => 2
    change_column :plants, :pH_Maximum, :decimal, :precision => 5, :scale => 2
  end

  def self.down
    change_column :sites, :lat, :decimal
    change_column :sites, :lon, :decimal
    change_column :sites, :zrt, :decimal
    change_column :sites, :zh2o, :decimal
    change_column :sites, :som, :decimal

    change_column :yields, :dateloc, :decimal
    change_column :yields, :mean, :decimal
    change_column :yields, :stat, :decimal

    change_column :traits, :dateloc, :decimal
    change_column :traits, :timeloc, :decimal
    change_column :traits, :mean, :decimal
    change_column :traits, :stat, :decimal

    change_column :priors, :parama, :decimal
    change_column :priors, :paramb, :decimal
    change_column :priors, :paramc, :decimal

    change_column :covariates, :level, :decimal

    change_column :managements, :dateloc, :decimal

    change_column :plants, :pH_Minimum, :decimal
    change_column :plants, :pH_Maximum, :decimal
  end
end
