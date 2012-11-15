class RunsInputs < ActiveRecord::Migration
  def self.up
     create_table :inputs_runs, :id => false do |t|
      t.references :input
      t.references :run

      t.timestamps
    end
    add_index(:inputs_runs, [:input_id, :run_id], :unique => true)

  end

  def self.down
    drop_table :inputs_runs
  end
end
