module Ilovepdf
  module Signature
    class InputElement
      include FileElement
      def initialize(file, label,description = nil)
        super(file)
        self.label=label
        self.description=description
        @type = :input
      end

      def set_info(label: "", description:)
        @info = {}.to_s
      end

      def label=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("value must be a String type of object") unless value.is_a?(String)
        self.set_info_parameter(:label,value)
      end

      def description=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("value must be a String type of object") unless value.is_a?(String)
        self.set_info_parameter(:description,value)
      end
    end
  end
end
