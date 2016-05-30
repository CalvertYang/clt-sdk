module Clt
  class CreditCard
    def initialize
      raise ArgumentError, "Please setup cocs_link_id first" if Clt.cocs_link_id.nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :cocs_link_id, data: "String") unless Clt.cocs_link_id.is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cocs_link_id) if Clt.cocs_link_id.empty?

      raise ArgumentError, "Please setup cocs_hash_base first" if Clt.cocs_hash_base.nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :cocs_hash_base, data: "String") unless Clt.cocs_hash_base.is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cocs_hash_base) if Clt.cocs_hash_base.empty?
    end

    # Order Create
    def order_create params = {}
      ErrorMessage.raise_argument_error(msg: :wrong_parameter_type, type: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      if params.has_key? :cust_order_no
        ErrorMessage.raise_argument_error(msg: :wrong_data, field: :cust_order_no, data: "String") unless params[:cust_order_no].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cust_order_no) if params[:cust_order_no].empty?
        ErrorMessage.raise_argument_error(msg: :data_length_too_short, field: :cust_order_no) if params[:cust_order_no].size < 3
      end

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_amount) if params[:order_amount].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :order_amount, data: "Integer") unless params[:order_amount].is_a? Fixnum

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_detail) if params[:order_detail].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :order_detail, data: "String") unless params[:order_detail].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :order_detail) if params[:order_detail].empty?

      if params.has_key? :limit_product_id
        ErrorMessage.raise_argument_error(msg: :wrong_data, field: :limit_product_id, data: "String") unless params[:limit_product_id].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :limit_product_id) if params[:limit_product_id].empty?
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
      data[:chk] = create_chk "#{Clt.cocs_hash_base}$#{params[:order_amount]}$#{data[:send_time]}"

      request(method: "POST", service_url: service_url, data: data)
    end

    # Order Cancel
    def order_cancel params = {}
      ErrorMessage.raise_argument_error(msg: :wrong_parameter_type, type: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :cust_order_no, data: "String") unless params[:cust_order_no].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cust_order_no) if params[:cust_order_no].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_amount) if params[:order_amount].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :order_amount, data: "Integer") unless params[:order_amount].is_a? Fixnum

      data = {
        link_id: Clt.cocs_link_id,
        send_time: Time.now.strftime("%F %T"),
        return_type: "json"
      }.merge(params)
      data[:chk] = create_chk "#{Clt.cocs_hash_base}$#{params[:cust_order_no]}$#{params[:order_amount]}$#{data[:send_time]}"

      request(method: "POST", service_url: params[:service_url], data: data)
    end

    # Order Refund
    def order_refund params = {}
      ErrorMessage.raise_argument_error(msg: :wrong_parameter_type, type: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :cust_order_no, data: "String") unless params[:cust_order_no].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cust_order_no) if params[:cust_order_no].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_amount) if params[:order_amount].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :order_amount, data: "Integer") unless params[:order_amount].is_a? Fixnum

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :refund_amount) if params[:refund_amount].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :refund_amount, data: "Integer") unless params[:refund_amount].is_a? Fixnum

      data = {
        link_id: Clt.cocs_link_id,
        send_time: Time.now.strftime("%F %T"),
        return_type: "json"
      }.merge(params)
      data[:chk] = create_chk "#{Clt.cocs_hash_base}$#{params[:cust_order_no]}$#{params[:order_amount]}$#{params[:refund_amount]}$#{data[:send_time]}"

      request(method: "POST", service_url: params[:service_url], data: data)
    end

    # Response data validation
    def data_valid? params
      chk = params["chk"]
      generated_chk = create_chk "#{Clt.cocs_hash_base}$#{params['order_amount']}$#{params['send_time']}$#{params['ret']}$#{params['acquire_time']}$#{params['auth_code']}$#{params['card_no']}$#{params['notify_time']}$#{params['cust_order_no']}"

      chk == generated_chk
    end

    private

      def create_chk data
        Digest::MD5.hexdigest data
      end

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
