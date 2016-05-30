[![Gem Version](https://badge.fury.io/rb/clt-sdk.svg)](http://badge.fury.io/rb/clt-sdk)
![Analytics](https://ga-beacon.appspot.com/UA-44933497-3/CalvertYang/clt-sdk?pixel)

# Clt SDK

Basic API client for President Collect Service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "clt-sdk"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install clt-sdk
```

## Usage

#### Initialize

```ruby
require "clt-sdk"

Clt.setup do |config|
  config.cvs_cust_id = "YOUR_CVS_CUST_ID"
  config.cvs_cust_password = "YOUR_CVS_CUST_PASSWORD"
  config.cvs_expire_after = 1
  config.cocs_link_id = "YOUR_COCS_LINK_ID"
  config.cocs_hash_base = "YOUR_COCS_HASH_BASE"
end
```

`cvs_expire_after`: [**Optional**] The ibon payment code will expired after this setting day (Default: 1)

## Example

* ibon

  ```ruby
  cvs = Clt::Cvs.new
  ```

  #### Order Create

  ```ruby
  result = cvs.order_create(
    service_url: "SERVICE_URL",
    order_number: "TESTORDER000001",
    amount: 100,
    mobile: "0987654321",
    email: "test@localhost.com"
  )
  ```

  Optional parameters: `name`, `postcode`, `address`

  #### Order Query

  ```ruby
  result = cvs.order_query(
    service_url: "SERVICE_URL",
    update_time_begin: "2016-05-27T00:00:00+08:00"
  )
  ```

  Optional parameters: `update_time_end`

* Credit Card

  ```ruby
  credit_card = Clt::CreditCard.new
  ```

  #### Order Create

  ```ruby
  result = credit_card.order_create(
    service_url: "SERVICE_URL",
    cust_order_no: "TESTORDER000001",
    order_amount: 100,
    order_detail: "Order Test"
  )
  ```

  Optional parameters: `cust_order_no`, `limit_product_id`

  > System will automatic generate `cust_order_no` if empty

  #### Order Cancel

  ```ruby
  result = credit_card.order_cancel(
    service_url: "SERVICE_URL",
    cust_order_no: "TESTORDER000001",
    order_amount: 100
  )
  ```

  #### Order Refund

  ```ruby
  result = credit_card.order_refund(
    service_url: "SERVICE_URL",
    cust_order_no: "TESTORDER000001",
    order_amount: 100,
    refund_amount: 100
  )
  ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CalvertYang/clt-sdk.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
