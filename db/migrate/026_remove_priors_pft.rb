class RemovePriorsPft < ActiveRecord::Migration
  def self.up
    remove_column :priors, :pft
  end


  def self.down
    add_column :priors, :pft, :integer
  end
end
