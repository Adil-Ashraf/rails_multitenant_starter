class Account < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  normalizes :name, with: ->(name) { name.strip }
  normalizes :slug, with: ->(slug) { slug.strip.downcase }

  validates :name, presence: true, length: { maximum: 100 }
  validates :slug, presence: true, uniqueness: { case_sensitive: false },
    format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
end
