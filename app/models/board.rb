class Board < ApplicationRecord

  belongs_to :residence
  has_many :reads, dependent: :destroy
  has_many :cercular_members, dependent: :destroy

end
