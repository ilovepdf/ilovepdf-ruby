module Ilovepdf
  module Tool
    class Officepdf < ::Ilovepdf::Task
      API_PARAMS = []
      attr_accessor *API_PARAMS

      def initialize(public_key, secret_key)
        self.tool = :officepdf
        super(public_key, secret_key)
      end
    end
  end
end
