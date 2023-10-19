class Facility < ApplicationRecord

  belongs_to :residence
  belongs_to :genre, optional: true
  has_many :reservations, dependent: :destroy
  has_one_attached :facility_image

  validates :name, presence: true

  # 設備画像が未設定だった場合、no_imageを表示
  def get_facility_image
    (facility_image.attached?) ? facility_image : "no_image.jpg"
  end

  def self.looks(words, member)
    @facilities = self.where(residence_id: member.residence_id)
    @facilities.where("name LIKE :word OR description LIKE :word OR note LIKE :word", word: "%#{words}%")
  end

end
