class User < ActiveRecord::Base
  attr_accessible :city, :country, :created_at, :email, :field, :login, :name, :postal_code, :state_prov, :updated_at
end
