class Category < ApplicationRecord
  has_many :profile_categories
  has_many :profiles, through: :profile_categories
end
