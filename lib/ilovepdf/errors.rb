module Ilovepdf
  # Base error classes
  class Error < StandardError
  end

  class ApiError < Error
    attr_accessor :http_response
    def initialize(http_response, custom_msg: nil)
      msg_to_use = custom_msg ? custom_msg : extract_error_text(http_response)
      super(msg_to_use)
      self.http_response = http_response
    end

    private
    def extract_error_text(http_response)
      r_body = http_response.body
      if r_body['name']
        title = r_body['name']
        msg   = r_body['message']
      elsif r_body['error']
        title = r_body['error']['type']
        msg   = r_body['error']['message']
        if r_body['error']['param']
          msg << " Details: " + r_body['error']['param'].to_s
        end
      else
        title = 'An error ocurred'
        msg = 'Check the response from the server'
      end
      "[#{title}] #{msg}"
    end
  end
  module Errors
    # Endpoint-specific errors
    class AuthError < ::Ilovepdf::ApiError
    end
    class ProcessError < ::Ilovepdf::ApiError
    end
    class StartError < ::Ilovepdf::ApiError
    end
    class UploadError < ::Ilovepdf::ApiError
    end
    class DownloadError < ::Ilovepdf::ApiError
    end

    # Library errors
    class ArgumentError < ::ArgumentError
    end
    
    class ArgumentEnumError < ArgumentError
      def initialize(valid_values)
        super("Provided argument is invalid. Valid values: #{valid_values.join(', ')}")
      end
    end
    class UnsupportedFunctionalityError < ::Ilovepdf::Error
    end
  end
end
