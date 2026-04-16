class Proposal < ApplicationRecord
  belongs_to :profile
  belongs_to :service_request

  validates :price, :status, presence: true
end
