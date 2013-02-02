class Citation < ActiveRecord::Base
  attr_accessible :author, :created_at, :doi, :journal, :pdf, :pg, :title, :updated_at, :url, :user_id, :vol, :year
end
