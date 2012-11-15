class AddCultivarPreviousId < ActiveRecord::Migration
  def self.up
    add_column :cultivars, :previous_id, :string
  end

  def self.down
    remove_column :cultivars, :previous_id
  end
end
