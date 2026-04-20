class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :trackable


  has_one :profile, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :service_requests, dependent: :destroy

  validates :name, presence: true

  def profile_incomplete?
    profile.nil? || profile.phone.blank? || profile.description.blank?
  end

  def address_incomplete?
    address.nil? || address.cep.blank? || address.street.blank? || address.number.blank? ||
      address.neighborhood.blank? || address.city.blank? || address.state.blank?
  end
end
