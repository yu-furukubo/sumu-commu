class LostItem < ApplicationRecord

  belongs_to :residence
  belongs_to :member, optional: true
  has_many :lost_item_comments, dependent: :destroy
  has_many_attached :lost_item_images

  validates :name, presence: true
  validates :picked_up_location, presence: true
  validates :picked_up_at, presence: true
  validates :storage_location, presence: true

  def self.looks(words, member)
    @lost_items = self.where(residence_id: member.residence_id)
    @lost_items.where("name LIKE :word OR description LIKE :word OR picked_up_location LIKE :word OR storage_location LIKE :word", word: "%#{words}%")
  end
end
