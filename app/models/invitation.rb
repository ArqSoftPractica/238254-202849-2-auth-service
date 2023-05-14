class Invitation < ActiveRecord::Base
  validates :email, :role, :companyId, :userId, presence: true
  validates :email, uniqueness: { scope: :companyId }
end
