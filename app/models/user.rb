class User < ActiveRecord::Base
  has_secure_password
  has_many :projects
  validates :name, uniqueness: true
  validates :email, uniqueness: true
  validates :password, presence: true
end
