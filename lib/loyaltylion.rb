require 'loyaltylion/version'
require 'loyaltylion/client'

module LoyaltyLion
  class << self
    def new(id, secret, options = {})
      LoyaltyLion::Client.new(id, secret, options)
    end
  end
end
