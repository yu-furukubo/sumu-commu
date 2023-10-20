class Event < ApplicationRecord

  belongs_to :residence
  belongs_to :member, optional: true
  has_many :event_members, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :started_at, presence: true
  validates :finished_at, presence: true
  validates :venue, presence: true

  def self.looks(words, residence)
    @events = self.where(residence_id: residence)
    @events.where("name LIKE :word OR description LIKE :word OR venue LIKE :word", word: "%#{words}%")
  end

end
