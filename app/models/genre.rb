class Genre < ApplicationRecord

  belongs_to :residence
  has_many :equipments
  has_many :facilities

  validates :name, presence: true

  def self.looks(words, residence)
    @genres = self.where(residence_id: residence)
    @genres.where("name LIKE :word", word: "%#{words}%")
  end

end
