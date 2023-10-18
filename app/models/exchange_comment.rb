class ExchangeComment < ApplicationRecord

  belongs_to :exchange
  belongs_to :member

end
