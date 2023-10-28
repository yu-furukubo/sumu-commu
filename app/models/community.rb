class Community < ApplicationRecord

  belongs_to :residence
  belongs_to :member
  has_many :community_comments, dependent: :destroy
  has_many :community_members, dependent: :destroy
  has_one_attached :community_image

  validates :name, presence: true

    # コミュニティ画像が未設定だった場合、no_imageを表示
  def get_community_image
    (community_image.attached?) ? community_image : "no_image_obj.png"
  end

  def self.looks(words, residence)
    @communities = self.where(residence_id: residence)
    @members = Member.where("name LIKE :word", word: "%#{words}%", residence_id: residence)
    @communities.where("name LIKE :word OR description LIKE :word", word: "%#{words}%").or(@communities.where(member_id: @members.pluck(:id)))
  end
end
