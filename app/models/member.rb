class Member < ApplicationRecord

  belongs_to :residence
  has_many :plans, dependent: :destroy
  has_many :reads, dependent: :destroy
  has_many :circular_members, dependent: :destroy
  has_many :exchanges, dependent: :destroy
  has_many :exchange_comments, dependent: :destroy
  has_many :communities
  has_many :community_comments, dependent: :destroy
  has_many :community_members, dependent: :destroy
  has_many :lost_items
  has_many :lost_item_comments, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :events
  has_many :event_members, dependent: :destroy
  has_many :boards
  has_one_attached :profile_image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # プロフィール画像が未設定だった場合、no_imageを表示
  def get_profile_image
    (profile_image.attached?) ? profile_image : "no_image.jpg"
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end
end
