module Ilovepdf
  module Tool
    class Pdfjpg < ::Ilovepdf::Task
      API_PARAMS = [:mode]

      MODE_VALUES = ['pages', 'extract']

      def initialize(public_key, secret_key)
        self.tool = :pdfjpg
        super(public_key, secret_key)
      end

      def mode=(new_val)
        raise Errors::ArgumentEnumError.new(MODE_VALUES) unless MODE_VALUES.include?(new_val)
        @mode = new_val
      end
      def mode
        @mode
      end
    end
  end
end
