class AddParentIdToPfts < ActiveRecord::Migration
  def self.up
    add_column :pfts, :parent_id, :integer
  end

  def self.down
    remove_column :pfts, :parent_id
  end
end
