class Pft < ActiveRecord::Base
  attr_accessible :created_at, :definition, :name, :parent_id, :updated_at
end
