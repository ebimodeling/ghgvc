class ChangeModelNameToSimlationModel < ActiveRecord::Migration
  def up
    rename_table :models, :simulationmodels
  end

  def down
    rename_table :simulationmodels, :models
  end
end
