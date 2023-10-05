class Equipment < ApplicationRecord

  belongs_to :residence
  belongs_to :genre
  has_many :reservations, dependent: :destroy
  has_one_attached :equipment_image

end
