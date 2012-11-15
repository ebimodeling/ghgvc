class InputsVariables < ActiveRecord::Migration
  def self.up
     create_table :inputs_variables, :id => false do |t|
      t.references :input
      t.references :variable

      t.timestamps
    end
    add_index(:inputs_variables, [:input_id, :variable_id], :unique => true)

  end

  def self.down
    drop_table :inputs_variables
  end
end
