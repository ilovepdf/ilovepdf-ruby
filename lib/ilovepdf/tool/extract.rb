module Ilovepdf
  module Tool
    class Extract < ::Ilovepdf::Task
      API_PARAMS = [:detailed]
      attr_accessor *API_PARAMS

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :extract
        super(public_key, secret_key, make_start)
      end

      def detailed
        @detailed ||= false
      end

    end
  end
end
