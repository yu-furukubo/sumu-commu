class Facility < ApplicationRecord

  belongs_to :residence
  belongs_to :genre
  has_many :reservations, dependent: :destroy
  has_one_attached :facility_image

  # 設備画像が未設定だった場合、no_imageを表示
  def get_facility_image
    (facility_image.attached?) ? facility_image : "no_image.jpg"
  end

end
