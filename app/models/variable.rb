class Variable < ActiveRecord::Base
  attr_accessible :created_at, :description, :max, :min, :name, :notes, :units, :updated_at
end
