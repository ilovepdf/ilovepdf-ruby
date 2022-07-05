module Ilovepdf
  module RequestPayload
    class FormUrlEncoded
      def initialize(body)
        raise ArgumentError.new("Body must be a hash") unless body.is_a?(Hash)
        @body = body
      end

      def mime_type
        'application/x-www-form-urlencoded'
      end

      def extract_to_s
        components = []

        @body.each do |key, value|
          resolved_val = stringify_into_form_format(key, value)
          components << resolved_val if !resolved_val.nil?
        end

        components.join("&")
      end

      private

      def stringify_into_form_format(key, value)
        components = []

        if value.is_a?(Hash)
          return nil if value.empty?
          value.each do|hk, hv|
            prop_name = URI.encode_www_form_component(hk)
            resolved_val = stringify_into_form_format("#{key}[#{prop_name}]", hv)
            components << resolved_val
          end
        elsif value.is_a?(Array)
          return nil if value.empty?
          value.each_with_index do |array_item, idx|
            resolved_val = stringify_into_form_format("#{key}[#{idx}]", array_item)
            next if resolved_val.nil?
            components << resolved_val
          end
        else
          return nil if value.nil?
          resolved_val = "#{key}=" + URI.encode_www_form_component(value)
          components << resolved_val
        end

        components.join("&")
      end

    end # /UrlEncoded class
  end
end