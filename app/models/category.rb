class Category < ApplicationRecord
  has_many :prolife_categories
  has_many :profiles, through: :prolife_categories
end
