module Ilovepdf
  module Helper
    extend self

    def underscore_str(str)
      str.replace(str.scan(/[A-Z][a-z]*/).join("_").downcase)
    end

    def camelize_str(str)
      str.split('_').map(&:capitalize).join
    end
  end
end
