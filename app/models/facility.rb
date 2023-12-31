class Facility < ApplicationRecord

  belongs_to :residence
  belongs_to :genre, optional: true
  has_many :reservations, dependent: :destroy
  has_one_attached :facility_image

  validates :name, presence: true
  validates :description, presence: true

  # 設備画像が未設定だった場合、no_imageを表示
  def get_facility_image
    (facility_image.attached?) ? facility_image : "no_image_obj.png"
  end

  def self.looks(words, residence)
    @facilities = self.where(residence_id: residence)
    @facilities.where("name LIKE :word OR description LIKE :word OR note LIKE :word", word: "%#{words}%")
  end

end
