# LoyaltyLion ruby-client

Use this to interact with the LoyaltyLion API from Ruby

## Installation

Add this line to your application's Gemfile:

    gem 'loyaltylion'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install loyaltylion

## Requirements

* Ruby 1.9.3 or above

## Usage

Create a new instance of `LoyaltyLion` with your LoyaltyLion token and secret, which are available from your [dashboard](https://loyaltylion.com/login). You can then

```ruby
require 'loyaltylion'

loyaltylion = LoyaltyLion.new(:token => 'abc', :secret => '123')
```

### Send a new order to LoyaltyLion

```ruby
loyaltylion.orders.create(
  :merchant_id => '34b8c96a3b',
  :customer_id => '71674',
  :customer_email => 'alice@example.com',
  :total => '59.95',
  :total_shipping => '5.95',
  :payment_status => 'unpaid',
)
```

The `orders.create` method accepts a hash containing all [supported fields](https://loyaltylion.com/docs/tracking-activities-and-orders#using-the-orders-api)

### Update an existing order

LoyaltyLion order updates are idempotent `PUT` operations. You can push an update to an existing order any time the order changes - our API will determine what changed and perform the appropriate action (e.g. approving points).

The first parameter should be the order's `merchant_id`, i.e. the id of the order in your system.

```ruby
loyaltylion.orders.update('34b8c96a3b',
  :payment_status => 'paid',
  :cancellation_status => 'not_cancelled',
  :refund_status => 'not_refunded',
  :total_paid => '59.95',
  :total_refunded => '0',
)
```

### Trigger an activity

```ruby
loyaltylion.activities.create(
  :name => 'signup',
  :customer_id => '1001',
  :customer_email => 'alice@example.com',
)
```

### Approve/decline an activity

If you've triggered a custom activity with a `merchant_id`, you can approve or decline the activity at a later date using the `activities.approve` and `activities.decline` methods.

These methods both expect the name of the custom activity (e.g. `review`) and the `merchant_id`.

```ruby
loyaltylion.activities.approve('review', '1001')
# or...
loyaltylion.activities.decline('review', '1001')
```

### Changelog

* v1.0.0 - overhaul client API, bring in-line with v2 LoyaltyLion API
