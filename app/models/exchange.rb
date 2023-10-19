class Exchange < ApplicationRecord

  belongs_to :residence
  belongs_to :member
  has_many :exchange_comments, dependent: :destroy
  has_many_attached :exchange_item_images

  validates :name, presence: true
  validates :price, presence: true
  validates :finished_at, presence: true

  def self.looks(words, member)
    @exchanges = self.where(residence_id: member.residence_id)
    @exchanges.where("name LIKE :word OR description LIKE :word", word: "%#{words}%")
  end

end
