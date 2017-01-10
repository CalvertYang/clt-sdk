[![Gem Version](https://badge.fury.io/rb/clt-sdk.svg)](http://badge.fury.io/rb/clt-sdk)
![Analytics](https://ga-beacon.appspot.com/UA-44933497-3/CalvertYang/clt-sdk?pixel)

# Clt SDK

API client for President Collect Service.

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
  config.cvs_cust_id = "CVS_CUST_ID"
  config.cvs_cust_password = "CVS_CUST_PASSWORD"
  config.cvs_default_expire_day = 3
  config.cocs_link_id = "COCS_LINK_ID"
  config.cocs_hash_base = "COCS_HASH_BASE"
end
```

`cvs_default_expire_day`: **Optional.** ibon code will expired after this day (Default: 1)

## Example

* ibon

  ```ruby
  cvs_client = Clt::Cvs.new
  ```

  #### Order Create

  ```ruby
  result = cvs_client.order_create(
    service_url: 'SERVICE_URL',
    cust_order_number: 'TESTORDER000001',
    order_amount: 100,
    payer_name: '測試',
    payer_postcode: '100',
    payer_address: '測試地址',
    payer_mobile: '0987654321',
    payer_email: 'test@localhost.com'
  )
  ```

  Optional parameters: `expire_date`

  > `expired_date` will overwrite `cvs_default_expire_day` setting.

  #### Order Query

  ```ruby
  result = cvs_client.order_query(
    service_url: 'SERVICE_URL',
    process_code_update_time_begin: '2017-01-01T00:00:00+08:00',
    process_code_update_time_end: '2017-01-01T23:59:59+08:00'
  )
  ```

* Credit Card

  ```ruby
  cocs_client = Clt::CreditCard.new
  ```

  > `chk` will be automatically generated.

  #### Order Create

  ```ruby
  result = cocs_client.order_create(
    service_url: 'SERVICE_URL',
    cust_order_no: 'TESTORDER000001',
    order_amount: 100,
    order_detail: 'Order Test'
  )
  ```

  Optional parameters: `cust_order_no`, `limit_product_id`, `chk`

  > `cust_order_no` will be automatically generated if empty.

  #### Order Cancel

  ```ruby
  result = cocs_client.order_cancel(
    service_url: 'SERVICE_URL',
    cust_order_no: 'TESTORDER000001',
    order_amount: 100
  )
  ```

  Optional parameters: `chk`

  #### Order Refund

  ```ruby
  result = cocs_client.order_refund(
    service_url: 'SERVICE_URL',
    cust_order_no: 'TESTORDER000001',
    order_amount: 100,
    refund_amount: 100
  )
  ```

  Optional parameters: `chk`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CalvertYang/clt-sdk.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
