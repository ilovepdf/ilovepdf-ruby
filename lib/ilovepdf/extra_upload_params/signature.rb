require 'ilovepdf/extra_upload_params/base'
module Ilovepdf
  module ExtraUploadParams
    
    class Signature < Base

      def set_pdf_info(activate = true)
        self.set_value(:pdfinfo,!!activate ? "1" : "0")
        self
      end

      def set_pdf_forms(activate = true)
        is_active = !!activate
        self.set_value(:pdfforms,is_active ? "1" : "0")
        if is_active
          self.set_pdf_info(true)
        end
        self
      end
    end

  end
end