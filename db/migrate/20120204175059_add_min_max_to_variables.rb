class AddMinMaxToVariables < ActiveRecord::Migration
  def self.up
    add_column :variables, :max, :string
    add_column :variables, :min, :string

  end

  def self.down
    remove_column :variables, :max
    remove_column :variables, :min
  end
end
