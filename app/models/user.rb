# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  login                     :string(40)
#  name                      :string(100)      default("")
#  email                     :string(100)
#  city                      :string(255)
#  country                   :string(255)
#  field                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  access_level              :integer
#  page_access_level         :integer
#  apikey                    :string(255)
#  state_prov                :string(255)
#  postal_code               :string(255)
#

class User < ActiveRecord::Base
  #specify what values a user can edit
  # For example "created_at" and updated_at" are excluded 
  # ... bc we assign that through the application, and don't want users editing those values
  attr_accessible :city, :country, :email, :field, :login, :name, :postal_code, :state_prov
end
