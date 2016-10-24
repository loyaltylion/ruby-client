require 'loyaltylion/models/resource'

module LoyaltyLion
  class Order < Resource
    def create(data)
      client.request(
        :method => :post,
        :path => '/orders',
        :body => data,
      )
    end

    def update(merchant_id, data)
      client.request(
        :method => :put,
        :path => "/orders/#{merchant_id}",
        :body => data,
      )
    end
  end
end
