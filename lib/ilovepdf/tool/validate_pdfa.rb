module Ilovepdf
  module Tool
    class ValidatePdfa < ::Ilovepdf::Task
      API_PARAMS = [:conformance]
      attr_accessor *API_PARAMS

      CONFORMANCE_VALUES = ['pdfa-1b', 'pdfa-1a', 'pdfa-2b', 'pdfa-2u',
                            'pdfa-2a', 'pdfa-3b', 'pdfa-3u', 'pdfa-3a'
                           ]

      def initialize(public_key, secret_key)
        self.tool = :validatepdfa
        super(public_key, secret_key)
      end

      def conformance= new_val
        raise Errors::ArgumentEnumError.new(CONFORMANCE_VALUES) unless CONFORMANCE_VALUES.include? new_val
        @conformance = new_val
      end

      def conformance
        @conformance ||= 'pdfa-2b'
      end

      private
      def download_file
        raise ::Ilovepdf::Errors::UnsupportedFunctionalityError.new('This tool does not download files (Check in the sample files how to use it)')
      end
    end
  end
end
