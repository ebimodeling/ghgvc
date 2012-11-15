class AddMimetype < ActiveRecord::Migration
  def self.up
    create_table :mimetypes do |t|
      t.string :type_string
    end
  end

  def self.down
    drop_table :mimetypes
  end
end
