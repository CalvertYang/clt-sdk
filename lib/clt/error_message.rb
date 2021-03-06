module Clt
  class ErrorMessage
    def self.raise_error(params)
      message = nil

      case params[:msg]
      when :missing_parameter
        message = "Missing required parameter: #{params[:field]}"
      when :parameter_should_be
        message = "#{params[:field]} should be #{params[:data]}"
      when :data_length_too_short
        message = "The length of #{params[:field]} is too short"
      when :wrong_data_format
        message = "The format of #{params[:field]} is wrong"
      when :cannot_be_empty
        message = "#{params[:field]} cannot be empty"
      end

      raise ArgumentError, message
    end
  end
end
