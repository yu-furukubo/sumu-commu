class Genre < ApplicationRecord

  belongs_to :residence
  has_many :equipments
  has_many :facilities

end
