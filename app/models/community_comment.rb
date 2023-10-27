class CommunityComment < ApplicationRecord

  belongs_to :community
  belongs_to :member

  validates :comment, presence: true

end
