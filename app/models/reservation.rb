class Reservation < ApplicationRecord

  belongs_to :residence
  belongs_to :equipment, optional: true
  belongs_to :facility, optional: true
  belongs_to :member, optional: true

  validates :start_date, presence: true
  validates :started_at, presence: true
  validates :finish_date, presence: true
  validates :finished_at, presence: true

  enum using_status: { reserved: 0, using: 1, returned: 2 }

end
