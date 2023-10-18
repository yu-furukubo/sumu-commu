class Residence < ApplicationRecord

  belongs_to :admin
  has_many :members, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_many :exchanges, dependent: :destroy
  has_many :communities, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :lost_items, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :equipments, dependent: :destroy
  has_many :facilities, dependent: :destroy
  has_many :genres, dependent: :destroy

  enum housing_type: { apartment: 0, house: 1 }

end
