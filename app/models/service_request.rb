class ServiceRequest < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :proposals
end
