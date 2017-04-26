require "bundler/setup"
require "byebug"
require 'webmock/rspec'
require "addressable/uri"
require "addressable/template"
require "ilovepdf"

WebMock.disable_net_connect!(allow_localhost: false)

module Ilovepdf
  module RSpec
    ENDPOINTS_URI_REGEXP = {
      start:    /api(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(start)(\/(.*))?/i,
      upload:   /api(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(upload)(\/(.*))?/i,
      process:  /api(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(process)(\/(.*))?/i,
      download: /api(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(download)(\/(.*))?/i,
      task:     /api(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(task)(\/(.*))?/i
    }

    class << self
      def get_default_response_for_endpoint(endpoint_name, request=nil)
        raise "Unknown key '#{endpoint_name}'" unless ENDPOINTS_DEFAULT_RESPONSES.has_key? endpoint_name
        response = ENDPOINTS_DEFAULT_RESPONSES[endpoint_name].clone
        response.tap {|h|
          h[:body] = h[:body].to_json unless endpoint_name.eql?(:download)
        }
      end
      def sample_pdf_filepath
        ::Ilovepdf.root.join("uploads/sample_pdf.pdf")
      end
    end

    ENDPOINTS_DEFAULT_RESPONSES = {
      start: {
        body:     {task: 'abc', server: "api400.ilovepdf.com"},
        headers:  { 'Content-Type' => 'application/json' }
      },
      upload:{
        body:     {server_filename: "abcdefghijkl"},
        headers:  { 'Content-Type' => 'application/json' }
      },
      process:{
        body:     {timer: '1.470'},
        headers:  { 'Content-Type' => 'application/json' }
      },
      download:{
        body:     ::File.read(sample_pdf_filepath, mode: 'rb'),
        headers:  { 'Content-Type' => 'application/pdf"',
                    'Content-Disposition' => "attachment; filename=\"sample_pdf.pdf\""
                  }
      },
      task:{
        body:     {server_filename: "abcdefghijkl"},
        headers:  { 'Content-Type' => 'application/json' }
      }
    }
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Mock API endpoints to return default responses and don't actually make real requests to the internet
  config.before(:each) do
    Ilovepdf::RSpec::ENDPOINTS_URI_REGEXP.each do |endpoint_name, template_uri|
      stub_request(:any, template_uri)
      .to_return { |request|
        Ilovepdf::RSpec.get_default_response_for_endpoint(endpoint_name, request)
      }
    end
  end
end
