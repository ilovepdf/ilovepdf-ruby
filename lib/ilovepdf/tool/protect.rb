module Ilovepdf
  module Tool
    class Protect < ::Ilovepdf::Task
      API_PARAMS = [:password]
      attr_accessor *API_PARAMS

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :protect
        super(public_key, secret_key, make_start)
      end
    end
  end
end
