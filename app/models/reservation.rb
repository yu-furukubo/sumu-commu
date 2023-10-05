class Reservation < ApplicationRecord

  belongs_to :residence
  belongs_to :equipment
  belongs_to :facility
  belongs_to :member

end
