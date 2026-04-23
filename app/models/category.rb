class Category < ApplicationRecord
  has_many :profile_categories
  has_many :profiles, through: :profile_categories
  has_many :service_requests

  validates :name, presence: true, uniqueness: true
end
