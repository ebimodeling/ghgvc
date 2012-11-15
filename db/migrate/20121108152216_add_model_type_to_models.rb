class AddModelTypeToModels < ActiveRecord::Migration
  def self.up
    add_column :models, :model_type, :string
    
    Model.update_all("model_type = 'ED2'", "model_name like 'ed%'")
    Model.update_all("model_type = 'SIPNET'", "model_name like 'sipnet%'")
  end

  def self.down
   remove_column :models, :model_type
  end
end
