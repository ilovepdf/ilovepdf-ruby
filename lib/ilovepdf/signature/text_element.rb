module Ilovepdf
  module Signature
    class TextElement
      include FileElement
      def initialize(file,text)
        super(file)
        @type = :text
        @content = text
      end

      def content=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("value must be a String type of object") unless s.is_a?(String)
        @content = value
      end
    end
  end
end
