class AddModelTypeToModels < ActiveRecord::Migration

  # hack for conflicts with having a model named "model"
  class Models < ActiveRecord::Base; end
  
  def self.up
    add_column :models, :model_type, :string
    
    Models.update_all("model_type = 'ED2'", "model_name like 'ed%'")
    Models.update_all("model_type = 'SIPNET'", "model_name like 'sipnet%'")
    Models.update_all("model_type = 'BIOCRO'", "model_name like 'biocro%'")
    
  end

  def self.down
   remove_column :models, :model_type
  end
end
