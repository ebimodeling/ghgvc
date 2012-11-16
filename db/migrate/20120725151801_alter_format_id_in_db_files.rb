class AlterFormatIdInDbFiles < ActiveRecord::Migration
  def self.up
    add_column :dbfiles, :format_id, :integer, {:null => false}
  end

  def self.down
    remove_column :dbfiles, :format_id
  end
end
