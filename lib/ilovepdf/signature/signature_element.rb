module Ilovepdf
  module Signature
    class SignatureElement
      include FileElement
      def initialize(file)
        super(file)
        @type = :signature
      end
    end
  end
end
