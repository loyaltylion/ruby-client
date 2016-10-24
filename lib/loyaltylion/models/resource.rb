module LoyaltyLion
  class Resource
    def initialize(client)
      @client = client
    end

    private

    attr_reader :client
  end
end
