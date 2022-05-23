require "bundler/setup"
require "byebug"
require 'webmock/rspec'
require "addressable/uri"
require "addressable/template"
require "ilovepdf"

WebMock.disable_net_connect!(allow_localhost: false)

module Ilovepdf
  module RSpec
    API_HOST = ::Ilovepdf::Servers::HOST
    ENDPOINTS_URI_REGEXP = {
      start:    /#{API_HOST}(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(start)(\/(.*))?/i,
      upload:   /#{API_HOST}(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(upload)(\/(.*))?/i,
      process:  /#{API_HOST}(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(process)(\/(.*))?/i,
      download: /#{API_HOST}(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(download)(\/(.*))?/i,
      task:     /#{API_HOST}(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(task)(\/(.*))?/i,
      signature:     /#{API_HOST}(\d+)?\.ilovepdf\.com(:\d+)?\/v1\/(signature)(\/(.*))?/i
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
        body:     {task: 'abc', server: "#{API_HOST}400.ilovepdf.com"},
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
      },
      signature:{
        body: {
            "about_to_expire_reminder": false,
            "completed_on": nil,
            "created": "2021-10-18 14:03:43",
            "disable_notifications": nil,
            "email": "email@email.com",
            "expires": "2022-02-15 15:00:00",
            "language": "en",
            "lock_order": false,
            "mode": "multiple",
            "name": "Guillem",
            "notes": nil,
            "signer_reminder_days_cycle": 2,
            "signer_reminders": true,
            "subject_cc": nil,
            "subject_signer": nil,
            "timezone": nil,
            "token_requester": "15928374asdf",
            "uuid": "18B06FDC-8643-447C-BAFB-9D3F8CA421B6",
            "uuid_visible": true,
            "verify_enabled": true,
            "expired": false,
            "expiring": false,
            "signers": [
                {
                    "uuid": "FCE3CAB9-2320-44C1-B18B-0F23BE2CF2FD",
                    "name": "name",
                    "email": "emailsigner@email.com",
                    "phone": nil,
                    "type": "signer",
                    "token_requester": "1234asdf",
                    "status": "waiting",
                    "access_code": false,
                    "phone_access_code": false,
                    "force_signature_type": "all",
                    "notes": nil
                }
            ],
            "files": [
                {
                    "filename": "sample.pdf",
                    "pages": 2,
                    "filesize": 22698
                }
            ],
            "certified": true,
            "status": "draft"
        },
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
