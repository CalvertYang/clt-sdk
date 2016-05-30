module Clt
  class ErrorMessage
    def self.raise_argument_error params
      message = nil

      case params[:msg]
      when :missing_parameter
        message = "Missing required parameter: #{params[:field]}"
      when :wrong_parameter_type
        message = "Parameter should be #{params[:type]}"
      when :wrong_data
        message = "#{params[:field]} should be #{params[:data]}"
      when :data_length_too_short
        message = "The length of #{params[:field]} is too short"
      when :wrong_format
        message = "The format for #{params[:field]} is wrong"
      when :cannot_be_empty
        message = "#{params[:field]} cannot be empty"
      end

      raise ArgumentError, message
    end
  end
end
