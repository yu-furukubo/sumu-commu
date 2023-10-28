class Exchange < ApplicationRecord

  belongs_to :residence
  belongs_to :member
  has_many :exchange_comments, dependent: :destroy
  has_many_attached :exchange_item_images

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true

  def self.looks(words, residence)
    @exchanges = self.where(residence_id: residence)
    @members = Member.where("name LIKE :word", word: "%#{words}%", residence_id: residence)
    @exchanges.where("name LIKE :word OR description LIKE :word", word: "%#{words}%").where('deadline > ?', Time.now).where(is_finished: false)
      .or(@exchanges.where("name LIKE :word OR description LIKE :word", word: "%#{words}%").where(deadline: nil).where(is_finished: false))
      .or(@exchanges.where(member_id: @members.pluck(:id)).where('deadline > ?', Time.now).where(is_finished: false))
      .or(@exchanges.where(member_id: @members.pluck(:id)).where(deadline: nil).where(is_finished: false))
  end

end
