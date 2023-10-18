class LostItem < ApplicationRecord

  belongs_to :residence
  belongs_to :member, optional: true
  has_many :lost_item_comments, dependent: :destroy
  has_many_attached :lost_item_images

end
