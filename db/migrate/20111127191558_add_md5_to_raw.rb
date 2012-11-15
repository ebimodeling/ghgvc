class AddMd5ToRaw < ActiveRecord::Migration
  def self.up
    add_column :raws, :md5, :string
  end

  def self.down
    remove_column :raws, :md5
  end
end
