module Ilovepdf
  module Tool
    class Repair < ::Ilovepdf::Task
      API_PARAMS = []

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :repair
        super(public_key, secret_key, make_start)
      end
    end
  end
end
