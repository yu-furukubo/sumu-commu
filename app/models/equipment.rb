class Equipment < ApplicationRecord

  belongs_to :residence
  belongs_to :genre
  has_many :reservations, dependent: :destroy
  has_one_attached :equipment_image

  # コミュニティ画像が未設定だった場合、no_imageを表示
  def get_equipment_image
    (equipment_image.attached?) ? equipment_image : "no_image.jpg"
  end

end
