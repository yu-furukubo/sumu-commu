class Plan < ApplicationRecord

  belongs_to :member

  validates :subject, presence: true
  validates :start_date, presence: true
  validates :started_at, presence: true
  validates :finish_date, presence: true
  validates :finished_at, presence: true

  before_save :set_the_day_implement

  private

  def set_the_day_implement
    start_year = self.start_date.year
    start_month = self.start_date.month
    start_day = self.start_date.day
    finish_year = self.finish_date.year
    finish_month = self.finish_date.month
    finish_day = self.finish_date.day

    self.started_at = self.started_at.change(year: start_year, month: start_month, day: start_day)
    self.finished_at = self.finished_at.change(year: finish_year, month: finish_month, day: finish_day)
  end
end
