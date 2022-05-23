require 'ilovepdf/file'
module Ilovepdf
    class SignatureFile < File
      attr_accessor :recipients
      def recipients
        @recipients ||= []
      end
    end
  end
end
