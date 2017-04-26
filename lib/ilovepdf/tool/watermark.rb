module Ilovepdf
  module Tool
    class Watermark < ::Ilovepdf::Task
      API_PARAMS = [
        :mode, :text, :image, :pages, :vertical_position, :horizontal_position,
        :vertical_position_adjustment, :horizontal_position_adjustment, :mosaic,
        :rotate, :font_family, :font_style, :font_size, :font_color, :transparency,
        :layer
      ]

      attr_accessor *API_PARAMS

      VERTICAL_POSITION_VALUES    = ['bottom', 'center' ,'top']
      HORIZONTAL_POSITION_VALUES  = ['left', 'middle', 'right']
      FONT_FAMILY_VALUES          = ['Arial', 'Arial Unicode MS', 'Verdana', 'Courier',
                                     'Times New Roman', 'Comic Sans MS', 'WenQuanYi Zen Hei',
                                     'Lohit Marathi'
                                    ]

      LAYER_VALUES = ['above', 'below']

      def initialize(public_key, secret_key)
        self.tool = :watermark
        super(public_key, secret_key)
      end

      def vertical_position=(new_val)
        raise Errors::ArgumentEnumError.new(VERTICAL_POSITION_VALUES) unless VERTICAL_POSITION_VALUES.include? new_val
        @vertical_position = new_val
      end

      def horizontal_position=(new_val)
        raise Errors::ArgumentEnumError.new(HORIZONTAL_POSITION_VALUES) unless HORIZONTAL_POSITION_VALUES.include? new_val
        @horizontal_position = new_val
      end

      def font_family=(new_val)
        raise Errors::ArgumentEnumError.new(FONT_FAMILY_VALUES) unless FONT_FAMILY_VALUES.include? new_val
        @font_family = new_val
      end

      def layer=(new_val)
        raise Errors::ArgumentEnumError.new(LAYER_VALUES) unless LAYER_VALUES.include? new_val
        @layer = new_val
      end

    end
  end
end
