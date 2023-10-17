class Reservation < ApplicationRecord

  belongs_to :residence
  belongs_to :equipment, optional: true
  belongs_to :facility, optional: true
  belongs_to :member, optional: true

  validates :start_date, presence: true
  validates :started_at, presence: true
  validates :finish_date, presence: true
  validates :finished_at, presence: true

  validate :validate_overlappings

  enum using_status: { reserved: 0, using: 1, returned: 2 }

  private

  def validate_overlappings
    if self.equipment_id.present?
      reservations = Reservation.where(equipment_id: self.equipment_id)
    elsif self.facility_id.present?
      reservations = Reservation.where(facility_id: self.facility_id)
    end
    if reservations.where('finished_at > ? and ? > started_at', self.started_at, self.finished_at)
      errors.add(:started_at, 'その期間にはすでに予約があります')
      errors.add(:finished_at, 'その期間にはすでに予約があります')
    end
    # TODO: equipment_id tsuika
    # TODO: equipment の時だけ実行
    # count = Reservation.where('finished_at > ? and ? > started_at', self.started_at, self.finished_at).count
    # count.times do
    #   self.stock += -1
    # end
    # if self.stock < 0
      # errors.add(:started_at, :finished_at, 'その期間にはすでに予約があります')
  end

end
