module Ilovepdf
  module Signature
    class DateElement
      include FileElement
      def initialize(file)
        super(file)
        @type = :date
      end

      def date_format=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("value must be a String type of object") unless value.is_a?(String)
        @content = value
      end
    end
  end
end
