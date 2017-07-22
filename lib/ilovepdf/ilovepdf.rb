module Ilovepdf
  class Ilovepdf
    attr_accessor :api_version, :token, :encrypt_key, :debug, :timeout, :long_timeout

    START_SERVER        = 'https://api.ilovepdf.com'.freeze
    API_VERSION         = 'ruby.v1'.freeze
    TOKEN_ALGORITHM     = 'HS256'.freeze
    ALL_ENDPOINTS       = [:start, :upload, :process, :download, :task].freeze
    LONG_JOB_ENDPOINTS  = [:process, :upload, :download].freeze

    TIME_DELAY = 5400

    def initialize(public_key=nil, secret_key=nil)
      set_api_keys(public_key, secret_key)
      api_version = API_VERSION
      self.timeout = 10
      self.long_timeout = nil
    end

    def new_task(tool_name)
      camelized_name = Helper.camelize_str(tool_name.to_s)
      task_klass = ::Ilovepdf::Tool.const_get(camelized_name) rescue false
      unless task_klass
        raise ::Ilovepdf::Error.new("Unknown tool '#{tool_name}'. Available tools: #{self.class.all_tool_names.to_s}")
      end
      task_klass.new(@public_key, @secret_key)
    end

    def self.all_tool_names
      ::Ilovepdf::Tool.constants.map{|tool_name| Helper.underscore_str(tool_name.to_s)}
    end

    def self.raise_exceptions=(value)
      @raise_exceptions = value
    end

    def self.raise_exceptions?
      @raise_exceptions.eql?(true)
    end

    def set_api_keys(public_key, secret_key)
      @public_key = public_key
      @secret_key = secret_key
    end

    def enable_file_encryption(enable, new_encrypt_key = nil)
      if enable
        if new_encrypt_key && ![16, 24, 32].include?(new_encrypt_key.size)
          raise ArgumentError.new("Encryption key must be 16, 24 or 32 characters long")
        end
        self.encrypt_key = new_encrypt_key || SecureRandom.hex(16)
      else
        self.encrypt_key = nil
      end
      nil
    end

    private

    def jwt
      raise Error.new('You must provide a set of API keys') unless api_keys_present?
      @token = JWT.encode jwt_token_payload, @secret_key, token_algorithm
    end

    def send_request(http_method, endpoint, extra_opts={})
      to_server = worker_server ? worker_server : START_SERVER

      timeout_to_use = LONG_JOB_ENDPOINTS.include?(endpoint.to_sym) ? self.long_timeout : self.timeout
      extra_opts[:body]     ||= {}
      extra_opts[:headers]  ||= {}

      extra_opts[:headers].merge!({
        'Accept' => 'application/json',
        'Authorization' => "Bearer " + jwt
      })

      extra_opts[:body][:debug] = true if self.debug

      request_uri = to_server + "/v1/#{endpoint}"
      begin
        rest_response = RestClient::Request.execute(  method: http_method.to_sym, url: request_uri, timeout: timeout_to_use,
                                                      headers: extra_opts[:headers], payload: extra_opts[:body]
                                                   )
        response = Response.new(rest_response)
      rescue RestClient::Unauthorized => e
        raise Errors::AuthError.new(Response.new(e.response))
      rescue RestClient::Exception => e
        raise klass_error_for(endpoint).new(Response.new(e.response))
      end

      response
    end

    def api_keys_present?
      !@public_key.nil? && !@secret_key.nil?
    end

    def klass_error_for(endpoint)
      error_klass = ::Ilovepdf::Errors.const_get("#{endpoint.to_s.capitalize}Error") rescue false
      error_klass = ::Ilovepdf::ApiError if !error_klass # use generic ApiError
      error_klass
    end

    def query_task_status(new_server, task_id)
      old_server     = worker_server
      worker_server  = new_server
      begin
        response = send_request('get', 'task/' + task_id.to_s)
      ensure
        worker_server = old_server
      end
      response
    end

    def jwt_token_payload
      current_time = Time.now.to_i
      params = {
        iss: '', # hostInfo
        aud: '', # hostInfo
        iat: current_time - TIME_DELAY,         # add some "delay"
        nbf: current_time - TIME_DELAY,         # add some "delay"
        exp: current_time + 3600 + TIME_DELAY,  # add some "delay"
        jti: @public_key
      }

      params[:file_encryption_key] = self.encrypt_key if is_file_encrypted?
      params
    end

    def worker_server; @worker_server; end
    def worker_server= new_server; @worker_server = new_server; end

    def is_file_encrypted?
      !self.encrypt_key.nil?
    end

    def token_algorithm
      TOKEN_ALGORITHM
    end

    def token
      @token
    end
  end # Ilovepdf
end
