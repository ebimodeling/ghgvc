class AddFieldsToCovariates < ActiveRecord::Migration
  def self.up

    add_column :covariates, :n, :integer
    add_column :covariates, :statname, :string
    add_column :covariates, :stat, :decimal, :precision => 16, :scale => 4
  end

  def self.down
    remove_column :covariates, :n
    remove_column :covariates, :statname
    remove_column :covariates, :stat
  end
end
