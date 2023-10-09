class Community < ApplicationRecord

  belongs_to :residence
  belongs_to :member
  has_many :community_comments, dependent: :destroy
  has_many :community_members, dependent: :destroy
  has_one_attached :community_image

    # コミュニティ画像が未設定だった場合、no_imageを表示
  def get_community_image
    (community_image.attached?) ? community_image : "no_image.jpg"
  end
end
