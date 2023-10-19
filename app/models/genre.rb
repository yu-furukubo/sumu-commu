class Genre < ApplicationRecord

  belongs_to :residence
  has_many :equipments
  has_many :facilities

  validates :name, presence: true

end
