module Ilovepdf
  module Tool
    class Merge < ::Ilovepdf::Task
      API_PARAMS = []
      attr_accessor *API_PARAMS

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :merge
        super(public_key, secret_key, make_start)
      end
    end
  end
end
