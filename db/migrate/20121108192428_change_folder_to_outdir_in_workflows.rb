class ChangeFolderToOutdirInWorkflows < ActiveRecord::Migration
  def self.up
    rename_column :workflows, :folder, :outdir
  end

  def self.down
    rename_column :workflows, :outdir, :folder
  end
end
