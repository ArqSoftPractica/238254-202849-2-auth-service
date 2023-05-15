class Invitation < ActiveRecord::Base
  enum role: %i[ADMIN EMPLOYEE]

  validates :email, :role, :companyId, :userId, presence: true
  validates :email, uniqueness: { scope: :companyId }
  validates :role, inclusion: { in: roles.keys }
end
