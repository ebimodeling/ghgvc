class CreateWorkflows < ActiveRecord::Migration
  def self.up
    create_table :workflows do |t|
      t.string :outdir
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE workflows
        AUTO_INCREMENT = 20;
    SQL

  end

  def self.down
    drop_table :workflows
    
    execute <<-SQL
      ALTER TABLE workflows
        AUTO_INCREMENT = 1;
    SQL
    
  end
end
