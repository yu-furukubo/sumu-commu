class Event < ApplicationRecord

  belongs_to :residence
  belongs_to :member, optional: true
  has_many :event_members, dependent: :destroy

end
