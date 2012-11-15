class AlterTreatmentsDef < ActiveRecord::Migration
  def self.up
    rename_column :treatments, :def, :definition

  end

  def self.down
    rename_column :treatments, :definition, :def

  end
end
