class CommunityComment < ApplicationRecord

  belongs_to :community
  belongs_to :member

end
