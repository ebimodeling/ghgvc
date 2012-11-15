class PosteriorsRuns < ActiveRecord::Migration
  def self.up
     create_table :posteriors_runs, :id => false do |t|
      t.references :posterior
      t.references :run

      t.timestamps
    end
    add_index(:posteriors_runs, [:posterior_id, :run_id], :unique => true)

  end

  def self.down
    drop_table :posteriors_runs
  end
end
