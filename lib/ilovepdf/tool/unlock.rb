module Ilovepdf
  module Tool
    class Unlock < ::Ilovepdf::Task
      API_PARAMS = []

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :unlock
        super(public_key, secret_key, make_start)
      end
    end
  end
end
