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

  # before_save :set_the_day_implement

  private

  # def set_the_day_implement
  #   start_year = self.start_date.year
  #   start_month = self.start_date.month
  #   start_day = self.start_date.day
  #   finish_year = self.finish_date.year
  #   finish_month = self.finish_date.month
  #   finish_day = self.finish_date.day

  #   self.started_at = self.started_at.change(year: start_year, month: start_month, day: start_day)
  #   self.finished_at = self.finished_at.change(year: finish_year, month: finish_month, day: finish_day)
  # end

  def validate_overlappings
    if self.equipment_id.present?
      reservations = Reservation.where(equipment_id: self.equipment_id)
    elsif self.facility_id.present?
      reservations = Reservation.where(facility_id: self.facility_id)
    end
     errors.add(:started_at, :finished_at, 'その期間にはすでに予約があります') if reservations.where('finished_at > ? and ? > started_at', self.started_at, self.finished_at)
    # count = Reservation.where('finished_at > ? and ? > started_at', self.started_at, self.finished_at).count
    # count.times do
    #   self.stock += -1
    # end
    # if self.stock < 0
      # errors.add(:started_at, :finished_at, 'その期間にはすでに予約があります')
  end

end
