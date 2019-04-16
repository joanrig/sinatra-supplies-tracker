class User < ActiveRecord::Base
  has_secure_password
  has_many :projects
  has_many :supplies
  validates :name, uniqueness: true
  validates :email, uniqueness: true
  validates :password, presence: true
end
