class Community < ApplicationRecord

  belongs_to :residence
  has_many :community_comments, dependent: :destroy
  has_many :community_members, dependent: :destroy
  has_one_attached :community_image

end
