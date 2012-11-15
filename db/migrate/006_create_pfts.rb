class CreatePfts < ActiveRecord::Migration
  def self.up
    create_table :pfts do |t|
      t.text :def

      t.timestamps
    end
  end

  def self.down
    drop_table :pfts
  end
end
