class CreateVisitors < ActiveRecord::Migration
  def self.up
    create_table :visitors do |t|
      t.string :ip
      t.text :page
      t.datetime :visitdate
      t.decimal :lat, :precision => 16, :scale => 8
      t.decimal :lon, :precision => 16, :scale => 8

      t.timestamps
    end
  end

  def self.down
    drop_table :visitors
  end
end
