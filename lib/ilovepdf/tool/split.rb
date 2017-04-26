module Ilovepdf
  module Tool
    class Split < ::Ilovepdf::Task
      API_PARAMS = [:ranges, :split_mode, :fixed_range, :remove_pages, :merge_after]
      attr_accessor *API_PARAMS

      def initialize(public_key, secret_key)
        self.tool = :split
        super(public_key, secret_key)
      end

      def fixed_range=(range=1)
        @split_mode = 'fixed_range'
        @fixed_range = range
      end

      def remove_pages=(pages)
        @split_mode = 'remove_pages'
        @remove_pages = pages
      end

      def ranges=(pages)
        @split_mode = 'ranges'
        @ranges = pages
      end

      def merge_after=(value)
        @merge_after = value
      end
      def merge_after
        @merge_after ||= false
      end
    end
  end
end
