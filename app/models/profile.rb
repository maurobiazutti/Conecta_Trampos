class Profile < ApplicationRecord
  belongs_to :user
  has_many :profile_categories
  has_many :categories, through: :profile_categories
  has_many :proposals

  accepts_nested_attributes_for :user
  def profile_incomplete?
    profile.nil? || profile.description.blank? || profile.phone.blank? || profile.name.blank?
  end
end
