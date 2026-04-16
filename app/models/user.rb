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

  validates :name, presence: true

  has_one :address, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :service_requests, dependent: :destroy
end
