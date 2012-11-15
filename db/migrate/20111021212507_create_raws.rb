class CreateRaws < ActiveRecord::Migration
  def self.up
    create_table :raws do |t|
      t.integer :site_id
      t.integer :format_id
      t.string :filepath
      t.text :notes
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
    add_column :inputs, :raw_id, :integer
    remove_column :inputs, :original_data
  end

  def self.down
    drop_table :raws
    remove_column :inputs, :raw_id
    add_column :inputs, :original_data, :string
  end
end
