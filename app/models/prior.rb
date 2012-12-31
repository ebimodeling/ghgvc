class Prior < ActiveRecord::Base
  attr_accessible :citation_id, :created_at, :distn, :n, :notes, :parama, :paramb, :paramc, :phylogeny, :updated_at, :variable_id
end
