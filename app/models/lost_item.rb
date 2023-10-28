class LostItem < ApplicationRecord

  belongs_to :residence
  belongs_to :member, optional: true
  has_many :lost_item_comments, dependent: :destroy
  has_many_attached :lost_item_images

  validates :name, presence: true
  validates :description, presence: true
  validates :picked_up_location, presence: true
  validates :picked_up_at, presence: true
  validates :storage_location, presence: true

  self.ignored_columns = [:deadline]

  def self.looks(words, residence)
    @lost_items = self.where(residence_id: residence)
    @members = Member.where("name LIKE :word", word: "%#{words}%", residence_id: residence)
    @admin = Admin.where("name LIKE :word", word: "%#{words}%")
    if @admin.present? && Residence.find_by(id: residence, admin_id: @admin.pluck(:id))
      @lost_items.where(is_finished: false)
        .where("name LIKE :word OR description LIKE :word OR picked_up_location LIKE :word OR storage_location LIKE :word", word: "%#{words}%")
        .or(@lost_items.where(member_id: @members.pluck(:id)).where(is_finished: false))
        .or(@lost_items.where(member_id: 0).where(is_finished: false))
    else
      @lost_items.where(is_finished: false)
        .where("name LIKE :word OR description LIKE :word OR picked_up_location LIKE :word OR storage_location LIKE :word", word: "%#{words}%")
        .or(@lost_items.where(member_id: @members.pluck(:id)).where(is_finished: false))
    end
  end
end
