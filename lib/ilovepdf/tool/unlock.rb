module Ilovepdf
  module Tool
    class Unlock < ::Ilovepdf::Task
      API_PARAMS = []

      def initialize(public_key, secret_key)
        self.tool = :unlock
        super(public_key, secret_key)
      end
    end
  end
end
