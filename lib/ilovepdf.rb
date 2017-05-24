require "ilovepdf/version"
require 'pathname'
require 'securerandom'

# 3rd party gems
require 'jwt'
require 'rest-client'

# Base classes
require "ilovepdf/errors"
require "ilovepdf/response"
require "ilovepdf/helper"
require "ilovepdf/ilovepdf"
require "ilovepdf/file"
require "ilovepdf/task"

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

module Ilovepdf
  class << self
    def root
      @root_path ||= Pathname.new(::File.dirname(::File.expand_path('../', __FILE__)))
    end
  end
end
