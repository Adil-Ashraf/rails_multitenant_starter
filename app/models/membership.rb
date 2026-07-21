class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :user

  enum :role, { member: 0, admin: 1, owner: 2 }, default: :member, validate: true

  validates :user_id, uniqueness: { scope: :account_id }
end
