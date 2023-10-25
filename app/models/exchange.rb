class Exchange < ApplicationRecord

  belongs_to :residence
  belongs_to :member
  has_many :exchange_comments, dependent: :destroy
  has_many_attached :exchange_item_images

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :deadline, presence: true

  def self.looks(words, residence)
    @exchanges = self.where(residence_id: residence)
    @exchanges.where("name LIKE :word OR description LIKE :word", word: "%#{words}%")
  end

end
