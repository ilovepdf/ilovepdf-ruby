module Ilovepdf
  module Signature
    class NameElement
      include FileElement
      def initialize(file)
        super(file)
        @type = :name
      end
    end
  end
end
