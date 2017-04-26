module Ilovepdf
  module Tool
    class Imagepdf < ::Ilovepdf::Task
      API_PARAMS = [:orientation, :margin, :pagesize, :merge_after]
      attr_accessor *API_PARAMS

      ORIENTATION_VALUES  = ['portrait', 'landscape']
      PAGESIZE_VALUES     = ['fit', 'A4', 'letter']

      def initialize(public_key, secret_key)
        self.tool = :imagepdf
        self.merge_after = true
        super(public_key, secret_key)
      end

      def orientation=(new_val)
        raise Errors::ArgumentEnumError.new(ORIENTATION_VALUES) unless ORIENTATION_VALUES.include? new_val
        @orientation = new_val
      end

      def pagesize=(new_val)
        raise Errors::ArgumentEnumError.new(PAGESIZE_VALUES) unless PAGESIZE_VALUES.include? new_val
        @pagesize = new_val
      end
    end
  end
end
