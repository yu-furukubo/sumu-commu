class Event < ApplicationRecord

  belongs_to :residence
  has_many :event_members, dependent: :destroy

end
