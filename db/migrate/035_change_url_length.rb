class ChangeUrlLength < ActiveRecord::Migration
  def self.up
    change_column :citations, :url, :string, :limit => 512
  end

  def self.down
    change_column :citations, :url, :string
  end
end
