module Ilovepdf
  module Tool
    class Pdfjpg < ::Ilovepdf::Task
      API_PARAMS = [
        :view_width, :view_height, :navigation_timeout, :delay,
        :page_size, :page_orientation, :page_margin, :remove_popups,
        :single_page
      ]
      attr_accessor *API_PARAMS

      PAGE_SIZE_VALUES        = ['A3', 'A4', 'A5', 'A6', 'Letter']
      PAGE_ORIENTATION_VALUES = ['portrait', 'landscape']

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :pdfjpg
        super(public_key, secret_key, make_start)

        # Assign default values
        self.view_width = 1920
        self.navigation_timeout = 10
        self.delay = 2
        self.page_margin = 0
        # raise Errors::ArgumentEnumError.new(CONFORMANCE_VALUES) unless CONFORMANCE_VALUES.include? new_val 
      end

      def navigation_timeout=(new_val)
      end

      def delay=(new_val)
      end

      def page_size=(new_val)
      end

      def page_orientation=(new_val)
      end

      def addUrl(file_url)
        add_file_from_url(file_url)
      end

    end
  end
end
