class ProjectSupply < ActiveRecord::Base
  belongs_to :project
  belongs_to :supply
end
