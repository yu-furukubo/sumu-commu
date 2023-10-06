class Board < ApplicationRecord

  belongs_to :residence
  has_many :reads, dependent: :destroy
  has_many :circular_members, dependent: :destroy

end
