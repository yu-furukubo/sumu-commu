class LostItemComment < ApplicationRecord

  belongs_to :lost_item
  belongs_to :member

end
