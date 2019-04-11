class Project < ActiveRecord::Base
  belongs_to :user
  has_many :project_supplies
  has_many :supplies, through: :project_supplies
  validates :name, :presence => true, :uniqueness => true
end
