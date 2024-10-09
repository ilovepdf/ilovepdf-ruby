module Ilovepdf
  class File
    attr_accessor :server_filename, :filename, :password, :info, :pdf_pages, :pdf_forms, :pdf_page_number
    attr_reader :rotate

    ROTATION_VALUES = [0, 90, 180, 270]

    def initialize(server_filename, filename)
      self.server_filename  = server_filename
      self.filename         = filename
      @deleted = false
    end

    def file_options
      h = {
        server_filename: self.server_filename,
        filename: self.filename,
        rotate: self.rotate
      }
      h[:password] = self.password if self.password
      h
    end

    # pageNumber is an integer and it must be greater than 1 (1 is the first page)
    def pdf_page_info(pageNumber)
      pdf_page_string = self.pdf_pages.at(pageNumber-1)
      width,height = 0.0
      return nil if !pdf_page_string.is_a?(String)
      PdfPage.initialize_from_string(pdf_page_string)
    end

    def last_pdf_page
      self.pdf_pages
    end

    def each_pdf_form_element
       self.pdf_forms&.each do |pdf_form_element|
        pdf_page = self.pdf_page_info(pdf_form_element['page'])
        yield(pdf_form_element,pdf_page)
      end
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
