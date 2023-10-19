class Board < ApplicationRecord

  belongs_to :residence
  belongs_to :member, optional: true
  has_many :reads, dependent: :destroy
  has_many :circular_members, dependent: :destroy

  validates :name, presence: true
  validates :body, presence: true

  def self.looks(words, member)
    @boards = self.where(residence_id: member.residence_id)
    @boards.where("name LIKE :word OR body LIKE :word", word: "%#{words}%")
  end
end
