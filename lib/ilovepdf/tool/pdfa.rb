module Ilovepdf
  module Tool
    class Pdfa < ::Ilovepdf::Task
      API_PARAMS = [:conformance, :allow_downgrade]
      attr_accessor *API_PARAMS

      CONFORMANCE_VALUES = ['pdfa-1b', 'pdfa-1a', 'pdfa-2b', 'pdfa-2u',
                            'pdfa-2a', 'pdfa-3b', 'pdfa-3u', 'pdfa-3a'
                           ]

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :pdfa
        super(public_key, secret_key, make_start)
        self.allow_downgrade = true
      end

      def conformance= new_val
        raise Errors::ArgumentEnumError.new(CONFORMANCE_VALUES) unless CONFORMANCE_VALUES.include? new_val
        @conformance = new_val
      end

      def conformance
        @conformance ||= 'pdfa-2b'
      end
    end
  end
end
