class Plan < ApplicationRecord

  belongs_to :member

  validates :subject, presence: true
  validates :start_date, presence: true
  validates :started_at, presence: true
  validates :finish_date, presence: true
  validates :finished_at, presence: true

end
