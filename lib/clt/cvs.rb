module Clt
  class Cvs
    def initialize
      raise ArgumentError, "Please setup cvs_cust_id first" if Clt.cvs_cust_id.nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :cvs_cust_id, data: "String") unless Clt.cvs_cust_id.is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cvs_cust_id) if Clt.cvs_cust_id.empty?

      raise ArgumentError, "Please setup cvs_cust_password first" if Clt.cvs_cust_password.nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :cvs_cust_password, data: "String") unless Clt.cvs_cust_password.is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :cvs_cust_password) if Clt.cvs_cust_password.empty?

      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :cvs_cust_password, data: "Integer") unless Clt.cvs_expire_after.is_a? Fixnum
    end

    def order_create params = {}
      ErrorMessage.raise_argument_error(msg: :wrong_parameter_type, type: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :order_number) if params[:order_number].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :order_number, data: "String") unless params[:order_number].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :order_number) if params[:order_number].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :amount) if params[:amount].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :amount, data: "Integer") unless params[:amount].is_a? Fixnum

      if params.has_key? :name
        ErrorMessage.raise_argument_error(msg: :wrong_data, field: :name, data: "String") unless params[:name].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :name) if params[:name].empty?
      end

      if params.has_key? :postcode
        ErrorMessage.raise_argument_error(msg: :wrong_data, field: :postcode, data: "String") unless params[:postcode].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :postcode) if params[:postcode].empty?
      end

      if params.has_key? :address
        ErrorMessage.raise_argument_error(msg: :wrong_data, field: :address, data: "String") unless params[:address].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :address) if params[:address].empty?
      end

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :mobile) if params[:mobile].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :mobile, data: "String") unless params[:mobile].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :mobile) if params[:mobile].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :email) if params[:email].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :email, data: "String") unless params[:email].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :email) if params[:email].empty?

      expire_date = get_cvs_expire_date

      # build xml data
      builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do
        request {
          header {
            cmd "cvs_order_regiater"
            cust_id Clt.cvs_cust_id
            cust_password Clt.cvs_cust_password
          }
          order {
            cust_order_number params[:order_number]
            order_amount params[:amount]
            expire_date expire_date
            payer_name params[:name] if params.has_key? :name
            payer_postcode params[:postcode] if params.has_key? :postcode
            payer_address params[:address] if params.has_key? :address
            payer_mobile params[:mobile]
            payer_email params[:email]
          }
        }
      end

      request(method: "POST", service_url: params[:service_url], data: builder.to_xml)
    end

    def order_query params = {}
      ErrorMessage.raise_argument_error(msg: :wrong_parameter_type, type: "Hash") unless params.is_a? Hash

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :service_url) if params[:service_url].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :service_url, data: "String") unless params[:service_url].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :service_url) if params[:service_url].empty?

      ErrorMessage.raise_argument_error(msg: :missing_parameter, field: :update_time_begin) if params[:update_time_begin].nil?
      ErrorMessage.raise_argument_error(msg: :wrong_data, field: :update_time_begin, data: "String") unless params[:update_time_begin].is_a? String
      ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :update_time_begin) if params[:update_time_begin].empty?

      if params.has_key? :update_time_end
        ErrorMessage.raise_argument_error(msg: :wrong_data, field: :update_time_end, data: "String") unless params[:update_time_end].is_a? String
        ErrorMessage.raise_argument_error(msg: :cannot_be_empty, field: :update_time_end) if params[:update_time_end].empty?
        ErrorMessage.raise_argument_error(msg: :wrong_format, field: :update_time_end) unless /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+\d{2}:\d{2}/.match(params[:update_time_end])
      end

      builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do
        request {
          header {
            cmd "cvs_order_query"
            cust_id Clt.cvs_cust_id
            cust_password Clt.cvs_cust_password
          }
          query {
            process_code_update_time_begin params[:update_time_begin]
            process_code_update_time_end params[:update_time_end] if params.has_key? :update_time_end
          }
        }
      end

      request(method: "POST", service_url: params[:service_url], data: builder.to_xml)
    end

    private

      def get_cvs_expire_date
        offset = 60 * 60 * 24 * Clt.cvs_expire_after

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