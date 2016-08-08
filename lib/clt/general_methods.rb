module Clt
  module GeneralMethods
    # APN(Active Payment Notification) response validation
    def apn_response_valid? params
      params = params.stringify_keys
      checksum = params["checksum"]
      new_checksum = generate_checksum "#{params['api_id']}:#{params['trans_id']}:#{params['amount']}:#{params['status']}:#{params['nonce']}"

      checksum == new_checksum
    end

    def generate_checksum data
      Digest::MD5.hexdigest data
    end
  end
end
