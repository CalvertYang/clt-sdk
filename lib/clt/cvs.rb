module Clt
  class Cvs
    include GeneralMethods

    def initialize
      raise ArgumentError, "Please setup cvs_cust_id first" if Clt.cvs_cust_id.nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cvs_cust_id, data: "String") unless Clt.cvs_cust_id.is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cvs_cust_id) if Clt.cvs_cust_id.empty?

      raise ArgumentError, "Please setup cvs_cust_password first" if Clt.cvs_cust_password.nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cvs_cust_password, data: "String") unless Clt.cvs_cust_password.is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cvs_cust_password) if Clt.cvs_cust_password.empty?

      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cvs_default_expire_day, data: "Integer") unless Clt.cvs_default_expire_day.is_a? Integer
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cvs_default_expire_day, data: "greater than 0") if Clt.cvs_default_expire_day <= 0
    end

    def order_create params = {}
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: "Parameter", data: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :cust_order_number) if params[:cust_order_number].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :cust_order_number, data: "String") unless params[:cust_order_number].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cust_order_number) if params[:cust_order_number].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_amount) if params[:order_amount].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :order_amount, data: "Integer") unless params[:order_amount].is_a? Integer

      if params.has_key? :expire_date
        ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :expire_date, data: "String") unless params[:expire_date].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :expire_date) if params[:expire_date].empty?
        ErrorMessage.raise_argument_error(msg: :wrong_data_format, field: :expire_date) unless /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+\d{2}:\d{2}\z/.match(params[:expire_date])
      end

      if params.has_key? :payer_name
        ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :payer_name, data: "String") unless params[:payer_name].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :payer_name) if params[:payer_name].empty?
      end

      if params.has_key? :payer_postcode
        ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :payer_postcode, data: "String") unless params[:payer_postcode].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :payer_postcode) if params[:payer_postcode].empty?
      end

      if params.has_key? :payer_address
        ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :payer_address, data: "String") unless params[:payer_address].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :payer_address) if params[:payer_address].empty?
      end

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :payer_mobile) if params[:payer_mobile].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :payer_mobile, data: "String") unless params[:payer_mobile].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :payer_mobile) if params[:payer_mobile].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :payer_email) if params[:payer_email].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :payer_email, data: "String") unless params[:payer_email].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :payer_email) if params[:payer_email].empty?

      expire_date = params.has_key?(:expire_date) ? params[:expire_date] : cvs_default_expire_date

      # build xml data
      builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do
        request {
          header {
            cmd "cvs_order_regiater"
            cust_id Clt.cvs_cust_id
            cust_password Clt.cvs_cust_password
          }
          order {
            cust_order_number params[:cust_order_number]
            order_amount params[:order_amount]
            expire_date expire_date
            payer_name params[:payer_name] if params.has_key? :payer_name
            payer_postcode params[:payer_postcode] if params.has_key? :payer_postcode
            payer_address params[:payer_address] if params.has_key? :payer_address
            payer_mobile params[:payer_mobile]
            payer_email params[:payer_email]
          }
        }
      end

      request(method: "POST", service_url: params[:service_url], data: builder.to_xml)
    end

    def order_query params = {}
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: "Parameter", data: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :process_code_update_time_begin) if params[:process_code_update_time_begin].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :process_code_update_time_begin, data: "String") unless params[:process_code_update_time_begin].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :process_code_update_time_begin) if params[:process_code_update_time_begin].empty?
      ErrorMessage.raise_argument_error(msg: :wrong_data_format, field: :process_code_update_time_begin) unless /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+\d{2}:\d{2}\z/.match(params[:process_code_update_time_begin])

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :process_code_update_time_end) if params[:process_code_update_time_end].nil?
      ErrorMessage.raise_argument_error(msg: :parameter_should_be, field: :process_code_update_time_end, data: "String") unless params[:process_code_update_time_end].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :process_code_update_time_end) if params[:process_code_update_time_end].empty?
      ErrorMessage.raise_argument_error(msg: :wrong_data_format, field: :process_code_update_time_end) unless /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+\d{2}:\d{2}\z/.match(params[:process_code_update_time_end])

      builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do
        request {
          header {
            cmd "cvs_order_query"
            cust_id Clt.cvs_cust_id
            cust_password Clt.cvs_cust_password
          }
          query {
            process_code_update_time_begin params[:process_code_update_time_begin]
            process_code_update_time_end params[:process_code_update_time_end]
          }
        }
      end

      request(method: "POST", service_url: params[:service_url], data: builder.to_xml)
    end

    private

      def get_cvs_default_expire_date
        seconds_in_a_day = 60 * 60 * 24
        offset = seconds_in_a_day * Clt.cvs_default_expire_day

        (Time.now + offset).iso8601
      end

      def request method: "POST", service_url:, data:
        api_url = URI.parse(service_url)

        http = Net::HTTP.new(api_url.host, api_url.port)
        http.use_ssl = true if api_url.scheme == "https"

        req = Net::HTTP::Post.new(api_url.request_uri, initheader = { "Content-Type" => "text/xml" })
        req.body = data

        response = http.request(req)

        case response
        when Net::HTTPOK
          parser = Nori.new(:advanced_typecasting => false)

          begin
            response_hash = parser.parse(response.body)["response"]
          rescue
            response_hash = { "status" => "ERROR", "msg" => "Response parsing failed", "response" => response.body }
          end

          response_hash
        when Net::HTTPClientError, Net::HTTPInternalServerError
          raise Net::HTTPError, response.message
        else
          raise Net::HTTPError, "Unexpected HTTP response"
        end
      end
  end
end
