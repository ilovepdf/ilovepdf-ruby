require "ilovepdf/version"
require 'pathname'
require 'securerandom'

# 3rd party gems
require 'jwt'
require 'rest-client'


# Base classes
require "ilovepdf/refinements"
require "ilovepdf/servers"
require "ilovepdf/errors"
require "ilovepdf/response"
require "ilovepdf/helper"
require "ilovepdf/ilovepdf"
require "ilovepdf/file"
require "ilovepdf/task"
require 'ilovepdf/element'
require 'ilovepdf/request_payload/form_url_encoded'
require 'ilovepdf/extra_upload_params/base'
require 'ilovepdf/extra_upload_params/signature'
require 'ilovepdf/pdf_page'

# Load tool classes
require 'ilovepdf/tool/compress'
require 'ilovepdf/tool/imagepdf'
require 'ilovepdf/tool/merge'
require 'ilovepdf/tool/officepdf'
require 'ilovepdf/tool/pagenumber'
require 'ilovepdf/tool/pdfa'
require 'ilovepdf/tool/validate_pdfa'
require 'ilovepdf/tool/pdfjpg'
require 'ilovepdf/tool/repair'
require 'ilovepdf/tool/rotate'
require 'ilovepdf/tool/split'
require 'ilovepdf/tool/unlock'
require 'ilovepdf/tool/watermark'
require 'ilovepdf/tool/protect'
require 'ilovepdf/tool/extract'
require 'ilovepdf/tool/signature'

# Load signature classes
require 'ilovepdf/signature'
require 'ilovepdf/signature/file_element'
require 'ilovepdf/signature/signature_element'
require 'ilovepdf/signature/initials_element'
require 'ilovepdf/signature/input_element'
require 'ilovepdf/signature/name_element'
require 'ilovepdf/signature/date_element'
require 'ilovepdf/signature/text_element'
require 'ilovepdf/signature/receiver'
require 'ilovepdf/signature/management'
require 'ilovepdf/tool/signature'

module Ilovepdf
  class << self
    def root
      @root_path ||= Pathname.new(::File.dirname(::File.expand_path('../', __FILE__)))
    end
  end
end
