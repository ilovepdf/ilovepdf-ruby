module Ilovepdf
  class Element
    FONT_FAMILY_VALUES = ['Arial', 'Arial Unicode MS', 'Verdana', 'Courier',
                            'Times New Roman', 'Comic Sans MS', 'WenQuanYi Zen Hei',
                            'Lohit Marathi'
                         ]

    VERTICAL_POSITION_VALUES    = ['bottom', 'middle' ,'top']
    HORIZONTAL_POSITION_VALUES  = ['left', 'center', 'right']

    LAYER_VALUES = ['above', 'below']
    
    ATTR_DEFAULT_VALUES = {
        type: 'text',
        mode: 'text',
        text: nil,
        image: nil,
        pages: 'all',
        vertical_position: 'middle',
        horizontal_position: 'center',
        vertical_adjustment: 0,
        horizontal_adjustment: 0,
        rotation: 0,
        transparency: 100,
        mosaic: false,
        font_family: nil,
        font_style: 'Regular',
        font_color: '#000000',
        font_size: 14,
        image_resize: 1,
        zoom: 1,
        gravity: 'center',
        border: nil,
        layer: nil,
        bold: false,
        server_filename: nil
      }

    attr_accessor *ATTR_DEFAULT_VALUES.keys

    def initialize(params={})
      init_values = ATTR_DEFAULT_VALUES.merge(params)
      init_values.delete_if{|k, v| v.nil? }
      init_values.each_pair do |k, v|
        public_send(:"#{k}=", v)
      end # /each_pair
    end # /initialize

    def font_family=(new_val)
      raise Errors::ArgumentEnumError.new(FONT_FAMILY_VALUES) unless FONT_FAMILY_VALUES.include? new_val
      @font_family = new_val
    end

    def layer=(new_val)
      raise Errors::ArgumentEnumError.new(LAYER_VALUES) unless LAYER_VALUES.include? new_val
      @layer = new_val
    end

    def vertical_position=(new_val)
      raise Errors::ArgumentEnumError.new(VERTICAL_POSITION_VALUES) unless VERTICAL_POSITION_VALUES.include? new_val
      @vertical_position = new_val
    end

    def horizontal_position=(new_val)
      raise Errors::ArgumentEnumError.new(HORIZONTAL_POSITION_VALUES) unless HORIZONTAL_POSITION_VALUES.include? new_val
      @horizontal_position = new_val
    end

    def to_api_hash
      export_hash = {}
      ATTR_DEFAULT_VALUES.keys.each do |k|
        val = send(k)
        export_hash[k] = val if !val.nil?
      end
      export_hash
    end

  end
end