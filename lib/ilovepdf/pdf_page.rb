module Ilovepdf
  class PdfPage
    attr_accessor :width,:height

    def initialize(width, height)
      self.width = width
      self.height = height
    end

    def self.initialize_from_string(string)
      width, height = string.split("x").map(&:to_f)
      PdfPage.new(width, height)
    end
  end
end