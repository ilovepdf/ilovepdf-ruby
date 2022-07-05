module Ilovepdf
  module Signature
    class Receiver
      ALLOWED_TYPES = [:signer,:validator,:viewer]

      attr_reader :type,:name,:email,:phone, :access_code,:force_signature_type
      def initialize(type,name,email, phone=nil)
        @type = type
        @name = name
        @email = email
        @phone = phone
      end

      def name=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("Only String type of object is allowed") if !value.is_a?(String) || value.empty?
        @name = value
      end

      def email=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("Only String type of object is allowed") if !value.is_a?(String) || value.empty?
        @email = value
      end

      def type=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("type is not valid, valid types are: #{value.join(", ")}") unless ALLOWED_TYPES.include?(value)
        @type = value
      end

      def phone=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("Only String type of object is allowed") unless value.is_a?(String)
        @phone = phone
      end

      def access_code=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("Only String type of object is allowed") unless value.is_a?(String)
        @access_code = value
      end

      def force_signature_type=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("Only String type of object is allowed") unless value.is_a?(String)
        @force_signature_type = value
      end

      def elements
        @elements ||= []
      end

      def <<(element)
        raise ::Ilovepdf::Errors::ArgumentError.new("Only Ilovepdf::Signature::FileElement type of object is allowed") unless element.is_a?(::Ilovepdf::Signature::FileElement)
        @elements ||= []
        @elements << element
        elements
      end
      alias_method :add_receiver,:<<

      def to_h
        {
          name: name,
          email: email,
          phone: phone,
          type: type,
          access_code: access_code,
          force_signature_type: force_signature_type,
          files: files_to_hash
        }
      end

      private

      def files_to_hash
        files_hash = @elements.inject({}) do |result,element|
          result[file.server_filename] ||= []
          result[file.server_filename] << element
          result
        end
        files_hash.inject([]) do |result,(server_filename,elements)|
          {
            server_filename: server_filename,
            elements: elements.map do |element|
              element.to_h
            end
          }
        end
      end
    end
  end
end
