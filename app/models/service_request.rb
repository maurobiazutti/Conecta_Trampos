class ServiceRequest < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :proposals

  validates :title, :description, :status, presence: true
end
