class RenameFormatsSchemaToDataformats < ActiveRecord::Migration
  def self.up
    rename_column :formats, :schema, :dataformat
  end

  def self.down
    rename_column :formats, :dataformat, :schema
  end
end
