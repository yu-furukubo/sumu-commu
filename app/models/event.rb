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
    @members = Member.where("name LIKE :word", word: "%#{words}%", residence_id: residence)
    @admin = Admin.where("name LIKE :word", word: "%#{words}%")
    if @admin.present? && Residence.find_by(id: residence, admin_id: @admin.pluck(:id))
      @events.where('finished_at > ?', Time.now)
        .where("name LIKE :word OR description LIKE :word OR venue LIKE :word", word: "%#{words}%")
        .or(@events.where('finished_at > ?', Time.now).where(member_id: @members.pluck(:id)))
        .or(@events.where('finished_at > ?', Time.now).where(member_id: 0))
    else
      @events.where('finished_at > ?', Time.now)
        .where("name LIKE :word OR description LIKE :word OR venue LIKE :word", word: "%#{words}%")
        .or(@events.where('finished_at > ?', Time.now).where(member_id: @members.pluck(:id)))

    end
  end

end
