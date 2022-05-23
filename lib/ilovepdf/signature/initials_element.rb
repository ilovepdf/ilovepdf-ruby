module Ilovepdf
  module Signature
    class InitialsElement
      include FileElement
      def initialize(file)
        super(file)
        @type = :initials
      end
    end
  end
end
