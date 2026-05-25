class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :name, presence: true
  validates :phone_number, presence: true, uniqueness: true

  has_one :donor_profile, dependent: :destroy
  has_many :blood_requests, dependent: :destroy
  has_many :blood_donation_requests, through: :donor_profile

  def is_donor?
    donor_profile.present?
  end
end
