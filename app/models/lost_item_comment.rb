class LostItemComment < ApplicationRecord

  belongs_to :lost_item
  belongs_to :member

  validates :comment, presence: true

end
