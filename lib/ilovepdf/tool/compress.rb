module Ilovepdf
  module Tool
    class Compress < ::Ilovepdf::Task
      API_PARAMS = [:compression_level]
      attr_accessor *API_PARAMS

      COMPRESSION_LEVEL_VALUES = ["extreme", "recommended", "low"]

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :compress
        super(public_key, secret_key, make_start)
      end

      def compression_level= level
        raise Errors::ArgumentEnumError.new(COMPRESSION_LEVEL_VALUES) unless COMPRESSION_LEVEL_VALUES.include? level
        @compression_level = level
      end
    end
  end
end
