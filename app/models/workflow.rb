class Workflow < ActiveRecord::Base
  attr_accessible :advanced_edit, :created_at, :end_date, :finished_at, :folder, :hostname, :model_id, :params, :site_id, :start_date, :started_at, :updated_at
end
