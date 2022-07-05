module Ilovepdf
  module Tool
    class Officepdf < ::Ilovepdf::Task
      API_PARAMS = []
      attr_accessor *API_PARAMS

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :officepdf
        super(public_key, secret_key, make_start)
      end
    end
  end
end
