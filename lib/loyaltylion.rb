require 'loyaltylion/version'
require 'loyaltylion/client'

module LoyaltyLion
  class << self
    def new(id, secret)
      LoyaltyLion::Client.new(id, secret)
    end
  end
end
