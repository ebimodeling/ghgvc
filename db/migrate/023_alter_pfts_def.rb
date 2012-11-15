class AlterPftsDef < ActiveRecord::Migration
  def self.up
    rename_column :pfts, :def, :definition

  end

  def self.down
    rename_column :pfts, :definition, :def

  end
end
