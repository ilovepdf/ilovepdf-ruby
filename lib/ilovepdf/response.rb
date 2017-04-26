module Ilovepdf
  class Response
    attr_accessor :response

    def initialize(response)
      raise ArgumentError.new('Argument must be of type \'RestClient::Response\'') unless response.is_a? ::RestClient::Response
      self.response = response
    end

    def headers
      self.response.headers
    end

    def body
      return @body if @body
      is_json = (/application\/json/i =~ self.response.headers[:content_type]) != nil
      if is_json
        @body ||= JSON.parse(self.response.body)
      else
        @body = self.response.body
      end
    end

    def raw_body
      self.response.body
    end

    def code
      self.response.code
    end

    def success?
      self.response.code.to_s[0] == '2'
    end
  end
end
