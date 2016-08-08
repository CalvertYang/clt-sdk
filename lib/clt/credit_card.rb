module Clt
  class CreditCard
    include GeneralMethods

    def initialize
      raise ArgumentError, "Please setup cocs_link_id first" if Clt.cocs_link_id.nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cocs_link_id, data: "String") unless Clt.cocs_link_id.is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cocs_link_id) if Clt.cocs_link_id.empty?

      raise ArgumentError, "Please setup cocs_hash_base first" if Clt.cocs_hash_base.nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cocs_hash_base, data: "String") unless Clt.cocs_hash_base.is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cocs_hash_base) if Clt.cocs_hash_base.empty?
    end

    # Order Create
    def order_create params = {}
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: "Parameter", data: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      if params.has_key? :cust_order_no
        ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cust_order_no, data: "String") unless params[:cust_order_no].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cust_order_no) if params[:cust_order_no].empty?
        ErrorMessage.raise_argument_error(msg: :data_length_too_short, field: :cust_order_no) if params[:cust_order_no].size < 3
      end

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_amount) if params[:order_amount].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :order_amount, data: "Integer") unless params[:order_amount].is_a? Integer
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :order_amount, data: "greater than 0") if params[:order_amount] <= 0

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_detail) if params[:order_detail].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :order_detail, data: "String") unless params[:order_detail].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :order_detail) if params[:order_detail].empty?

      if params.has_key? :limit_product_id
        ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :limit_product_id, data: "String") unless params[:limit_product_id].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :limit_product_id) if params[:limit_product_id].empty?
      end

      if params.has_key? :chk
        raise_argument_error(msg: :parameter_should_be, field: :chk, data: "String") unless params[:chk].is_a? String
        raise_argument_error(msg: :cannot_be_empty, field: :chk) if params[:chk].empty?
      end

      service_url = params[:service_url]
      params.delete :service_url

      data = {
        link_id: Clt.cocs_link_id,
        cust_order_no: "",
        limit_product_id: "esun.normal",
        send_time: Time.now.strftime("%F %T"),
        return_type: "json"
      }.merge(params)

      unless params.has_key? :chk
        data[:chk] = generate_checksum "#{Clt.cocs_hash_base}$#{params[:order_amount]}$#{data[:send_time]}"
      end

      request(method: "POST", service_url: service_url, data: data)
    end

    # Order Cancel
    def order_cancel params = {}
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: "Parameter", data: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cust_order_no, data: "String") unless params[:cust_order_no].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cust_order_no) if params[:cust_order_no].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_amount) if params[:order_amount].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :order_amount, data: "Integer") unless params[:order_amount].is_a? Integer
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :order_amount, data: "greater than 0") if params[:order_amount] <= 0

      if params.has_key? :chk
        raise_argument_error(msg: :parameter_should_be, field: :chk, data: "String") unless params[:chk].is_a? String
        raise_argument_error(msg: :cannot_be_empty, field: :chk) if params[:chk].empty?
      end

      data = {
        link_id: Clt.cocs_link_id,
        send_time: Time.now.strftime("%F %T"),
        return_type: "json"
      }.merge(params)

      unless params.has_key? :chk
        data[:chk] = generate_checksum "#{Clt.cocs_hash_base}$#{params[:cust_order_no]}$#{params[:order_amount]}$#{data[:send_time]}"
      end

      request(method: "POST", service_url: params[:service_url], data: data)
    end

    # Order Refund
    def order_refund params = {}
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: "Parameter", data: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cust_order_no, data: "String") unless params[:cust_order_no].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cust_order_no) if params[:cust_order_no].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_amount) if params[:order_amount].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :order_amount, data: "Integer") unless params[:order_amount].is_a? Integer
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :order_amount, data: "greater than 0") if params[:order_amount] <= 0

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :refund_amount) if params[:refund_amount].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :refund_amount, data: "Integer") unless params[:refund_amount].is_a? Integer
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :refund_amount, data: "greater than 0") if params[:refund_amount] <= 0

      if params[:refund_amount] > params[:order_amount]
        ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :refund_amount, data: "less than or equal to order_amount")
      end

      if params.has_key? :chk
        raise_argument_error(msg: :parameter_should_be, field: :chk, data: "String") unless params[:chk].is_a? String
        raise_argument_error(msg: :cannot_be_empty, field: :chk) if params[:chk].empty?
      end

      data = {
        link_id: Clt.cocs_link_id,
        send_time: Time.now.strftime("%F %T"),
        return_type: "json"
      }.merge(params)

      unless params.has_key? :chk
        data[:chk] = generate_checksum "#{Clt.cocs_hash_base}$#{params[:cust_order_no]}$#{params[:order_amount]}$#{params[:refund_amount]}$#{data[:send_time]}"
      end

      request(method: "POST", service_url: params[:service_url], data: data)
    end

    # Authorize success response validation
    def auth_success_response_valid? params
      params = params.stringify_keys
      checksum = params["chk"]
      new_checksum = generate_checksum "#{Clt.cocs_hash_base}$#{params['order_amount']}$#{params['send_time']}$#{params['ret']}$#{params['acquire_time']}$#{params['auth_code']}$#{params['card_no']}$#{params['notify_time']}$#{params['cust_order_no']}"

      checksum == new_checksum
    end

    # Authorize fail response validation
    def auth_fail_response_valid? params
      params = params.stringify_keys
      checksum = params["chk"]
      new_checksum = generate_checksum "#{Clt.cocs_hash_base}$#{params['order_amount']}$#{params['send_time']}$#{params['ret']}$#{params['notify_time']}$#{params['cust_order_no']}"

      checksum == new_checksum
    end

    private

      def request method:, service_url:, data:
        api_url = URI.parse(service_url)
        response = Net::HTTP.post_form api_url, data

        case response
        when Net::HTTPOK
          begin
            result = JSON.parse(response.body)
          rescue
            result = { "status" => "ERROR", "msg" => "Response parsing failed", "response" => response.body }
          end

          result
        when Net::HTTPClientError, Net::HTTPInternalServerError
          raise Net::HTTPError, response.message
        else
          raise Net::HTTPError, "Unexpected HTTP response"
        end
      end
  end
end
