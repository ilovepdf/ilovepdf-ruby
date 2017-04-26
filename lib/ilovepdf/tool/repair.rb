module Ilovepdf
  module Tool
    class Repair < ::Ilovepdf::Task
      API_PARAMS = []

      def initialize(public_key, secret_key)
        self.tool = :repair
        super(public_key, secret_key)
      end
    end
  end
end
