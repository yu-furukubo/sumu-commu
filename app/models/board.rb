class Board < ApplicationRecord

  belongs_to :residence
  belongs_to :member, optional: true
  has_many :reads, dependent: :destroy
  has_many :circular_members, dependent: :destroy

  validates :name, presence: true
  validates :body, presence: true

  def self.looks(words, residence)
    @boards = self.where(residence_id: residence)
    @members = Member.where("name LIKE :word", word: "%#{words}%", residence_id: residence)
    @admin = Admin.where("name LIKE :word", word: "%#{words}%")
    if @admin.present? && Residence.find_by(id: residence, admin_id: @admin.pluck(:id))
      @boards
      .where("name LIKE :word OR body LIKE :word", word: "%#{words}%")
      .or(@boards.where(member_id: @members.pluck(:id)))
      .or(@boards.where(member_id: 0))
    else
      @boards
      .where("name LIKE :word OR body LIKE :word", word: "%#{words}%")
      .or(@boards.where(member_id: @members.pluck(:id)))
    end
  end
end
