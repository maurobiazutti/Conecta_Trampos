class Address < ApplicationRecord
  belongs_to :user

  validates :cep, :street, :number, :neighborhood, :city, :state, presence: true
end
