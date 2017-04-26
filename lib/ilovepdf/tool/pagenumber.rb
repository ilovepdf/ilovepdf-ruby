module Ilovepdf
  module Tool
    class Pagenumber < ::Ilovepdf::Task
      API_PARAMS = [
        :facing_pages, :first_cover, :pages, :starting_number, :vertical_position,
        :horizontal_position, :vertical_position_adjustment, :horizontal_position_adjustment,
        :font_family, :font_style, :font_size, :font_color, :text
      ]

      attr_accessor *API_PARAMS

      VERTICAL_POSITION_VALUES    = ['bottom', 'top']
      HORIZONTAL_POSITION_VALUES  = ['left', 'middle', 'right']
      FONT_FAMILY_VALUES          = [ 'Arial', 'Arial Unicode MS', 'Verdana', 'Courier',
                                      'Times New Roman', 'Comic Sans MS',
                                      'WenQuanYi Zen Hei', 'Lohit Marathi'
                                    ]

      def initialize(public_key, secret_key)
        self.tool = :pagenumber
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
    end
  end
end
