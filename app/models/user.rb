class User < ActiveRecord::Base
  USER_ROLES = %w[ADMIN EMPLOYEE].freeze

  validates :email, :password, :role, presence: true
  validates :email, uniqueness: true
  validates :role, inclusion: { in: USER_ROLES }

  has_secure_password :password, validations: false
end
