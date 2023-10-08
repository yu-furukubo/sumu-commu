class Board < ApplicationRecord

  belongs_to :residence
  belongs_to :member, optional: true
  has_many :reads, dependent: :destroy
  has_many :circular_members, dependent: :destroy

end
