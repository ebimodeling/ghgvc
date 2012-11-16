class CreateServices < ActiveRecord::Migration
  def self.up
#    create_table :services do |t|
#      t.integer  "site_id"
#      t.integer  "specie_id"
#      t.integer  "citation_id"
#      t.integer  "cultivar_id"
#      t.integer  "treatment_id"
#      t.datetime "date"
#      t.decimal  "dateloc",      :precision => 4,  :scale => 2
#      t.time     "time"
#      t.decimal  "timeloc",      :precision => 4,  :scale => 2
#      t.decimal  "mean",         :precision => 16, :scale => 4
#      t.integer  "n"
#      t.string   "statname"
#      t.decimal  "stat",         :precision => 16, :scale => 4
#      t.text     "notes"
#      t.integer  "variable_id"
#      t.integer  "user_id"
#      t.boolean  "checked",                                     :default => false
#      t.integer  "access_level"
#
#      t.timestamps
#    end
  end

  def self.down
#    drop_table :services
  end
end
