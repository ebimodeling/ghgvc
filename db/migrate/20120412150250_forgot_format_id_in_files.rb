class ForgotFormatIdInFiles < ActiveRecord::Migration
  def self.up

    add_column :input_files, :format_id, :integer
  end

  def self.down
    remove_column :input_files, :format_id
  end
end
