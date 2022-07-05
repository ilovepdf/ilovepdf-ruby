module Ilovepdf
  module Tool
    class Rotate < ::Ilovepdf::Task
      API_PARAMS = []

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :rotate
        super(public_key, secret_key, make_start)
      end
    end
  end
end
