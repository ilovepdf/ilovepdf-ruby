module Ilovepdf
  module Tool
    class Watermark < ::Ilovepdf::Task
      API_PARAMS = [
        :mode, :text, :image, :pages, :vertical_position, :horizontal_position,
        :vertical_position_adjustment, :horizontal_position_adjustment, :mosaic,
        :rotate, :font_family, :font_style, :font_size, :font_color, :transparency,
        :layer, :elements
      ]

      MODE_VALUES = ['image', 'text', 'multi']

      attr_accessor *API_PARAMS

      def initialize(public_key, secret_key)
        self.tool = :watermark
        super(public_key, secret_key)
      end

      def add_element(element)
        raise Errors::ArgumentError.new("Element must be of type 'Ilovepdf::Element'") unless element.instance_of?(::Ilovepdf::Element)
        elements << element
      end

      def elements
        @elements ||= []
      end

      def mode=(new_val)
        raise Errors::ArgumentEnumError.new(MODE_VALUES) unless MODE_VALUES.include? new_val
        @mode = new_val
      end

      def vertical_position=(new_val)
        raise Errors::ArgumentEnumError.new(::Ilovepdf::Element::VERTICAL_POSITION_VALUES) unless ::Ilovepdf::Element::VERTICAL_POSITION_VALUES.include? new_val
        @vertical_position = new_val
      end

      def horizontal_position=(new_val)
        raise Errors::ArgumentEnumError.new(::Ilovepdf::Element::HORIZONTAL_POSITION_VALUES) unless ::Ilovepdf::Element::HORIZONTAL_POSITION_VALUES.include? new_val
        @horizontal_position = new_val
      end

      def font_family=(new_val)
        raise Errors::ArgumentEnumError.new(::Ilovepdf::Element::FONT_FAMILY_VALUES) unless ::Ilovepdf::Element::FONT_FAMILY_VALUES.include? new_val
        @font_family = new_val
      end

      def layer=(new_val)
        raise Errors::ArgumentEnumError.new(::Ilovepdf::Element::LAYER_VALUES) unless ::Ilovepdf::Element::LAYER_VALUES.include? new_val
        @layer = new_val
      end

      private

      # Do nothing;
      def elements=(val)
      end

      def extract_api_param_value(param_name)
        return self.elements.map{|elem| elem.to_api_hash } if param_name == :elements 
        super
      end # /extract_api_param_value

    end
  end
end
