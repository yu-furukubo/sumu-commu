class Equipment < ApplicationRecord

  belongs_to :residence
  belongs_to :genre, optional: true
  has_many :reservations, dependent: :destroy
  has_one_attached :equipment_image

  validates :name, presence: true
  validates :description, presence: true
  validates :storage_location, presence: true
  validates :return_location, presence: true

  # 備品画像が未設定だった場合、no_imageを表示
  def get_equipment_image
    (equipment_image.attached?) ? equipment_image : "no_image.jpg"
  end

  def self.looks(words, residence)
    @equipments = self.where(residence_id: residence)
    @equipments.where("name LIKE :word OR description LIKE :word OR storage_location LIKE :word OR return_location LIKE :word OR note LIKE :word", word: "%#{words}%")
  end

end
