class CreateModels < ActiveRecord::Migration
  def self.up
    create_table :models do |t|
      t.string :model_name
      t.string :model_path
      t.decimal :revision
      t.references :parent

      t.timestamps
    end
  end

  def self.down
    drop_table :models
  end
end
