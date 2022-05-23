module Ilovepdf
  class File
    attr_accessor :server_filename, :filename, :password, :info
    attr_reader :rotate

    ROTATION_VALUES = [0, 90, 180, 270]

    def initialize(server_filename, filename)
      self.server_filename  = server_filename
      self.filename         = filename
      @deleted = false
    end

    def file_options
      {
        server_filename: self.server_filename,
        filename: self.filename,
        rotate: self.rotate,
        password: self.password
      }
    end

    def rotate= degrees
      raise Errors::ArgumentEnumError.new(ROTATION_VALUES) unless ROTATION_VALUES.include? degrees
      @rotate = degrees
    end

    def mark_as_deleted
      @deleted = true
    end

    def deleted?
      @deleted
    end
  end
end
