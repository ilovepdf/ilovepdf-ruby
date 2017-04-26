module Ilovepdf
  module Tool
    class Rotate < ::Ilovepdf::Task
      API_PARAMS = []

      def initialize(public_key, secret_key)
        self.tool = :rotate
        super(public_key, secret_key)
      end
    end
  end
end
