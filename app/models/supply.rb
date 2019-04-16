class Supply < ActiveRecord::Base
  has_many :project_supplies
  has_many :projects, through: :project_supplies
  belongs_to :user
end
