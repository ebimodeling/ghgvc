class AlterFormatIdInDbFiles < ActiveRecord::Migration
  def self.up
    change_column :dbfiles, :format_id, :integer, {:null => false}
  end

  def self.down
    change_column :dbfiles, :format_id, :integer, {:null => true}
  end
end
