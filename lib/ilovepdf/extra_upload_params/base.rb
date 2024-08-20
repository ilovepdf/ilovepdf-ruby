module Ilovepdf
  module ExtraUploadParams
    class Base
      attr_accessor :extra_params
      
      def set_value(key,value)
        self.extra_params||= {}
        self.extra_params[key] = value
      end
      
      def get_values()
        self.extra_params
      end
      
    end
  end
end