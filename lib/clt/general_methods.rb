module Clt
  module GeneralMethods
    # APN(Active Payment Notification) notice validation
    def apn_notice_valid?(params)
      params = params.stringify_keys
      checksum = params['checksum']
      checksum_generated = generate_checksum "#{params['api_id']}:#{params['trans_id']}:#{params['amount']}:#{params['status']}:#{params['nonce']}"

      checksum == checksum_generated
    end

    def generate_checksum(data)
      Digest::MD5.hexdigest data
    end
  end
end
