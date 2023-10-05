class Exchange < ApplicationRecord

  belongs_to :residence
  belongs_to :member
  has_many :exchange_comments, dependent: :destroy
  has_many_attached :exchange_item_images

end
