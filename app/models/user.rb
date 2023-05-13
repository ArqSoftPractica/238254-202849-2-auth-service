class User < ActiveRecord::Base
  enum role: %i[ADMIN EMPLOYEE]

  validates :email, :password, presence: true
  validates :email, uniqueness: true
  validates :role, inclusion: { in: roles.keys }

  has_secure_password
end
