module Ilovepdf
  module Signature
    class Management < ::Ilovepdf::Task

      def initialize(public_key, secret_key, make_start=false)
        self.tool = :sign
        super(public_key, secret_key, make_start)
      end

      def get_status(signature_token)
        send_request("get", "signature/requesterview/#{signature_token}")
      end

      def list_signatures(current_page: 0,per_page: 20)
        send_request("get", "signature/list", body: {page: current_page,per_page: per_page})
      end

      def download_audit(signature_token, directory = __dir__,create_directory: true,filename:)
        download_file("signature/#{signature_token}/download-audit",directory,create_directory: create_directory, filename: filename)
      end

      def download_original(signature_token, directory¡,create_directory: true,filename:)
        download_file("signature/#{signature_token}/download-original",directory,{create_directory: create_directory, filename: filename})
      end

      def download_signed(signature_token, directory = __dir__,create_directory: true,filename:)
        download_file("signature/#{signature_token}/download-signed",directory,{create_directory: create_directory, filename: filename})
      end

      def send_reminders(signature_token)
        send_request("post","signature/sendReminder/#{signature_token}")
      end

      def void_signature(signature_token)
        send_request("put","signature/void/#{signature_token}")
      end

      def increase_expiration_days(signature_token,days_to_increase)
        body = {days: days_to_increase}
        extracted_body = RequestPayload::FormUrlEncoded.new(body).extract_to_s
        send_request("put","signature/increase-expiration-days/#{signature_token}", body: extracted_body)
      end

      def get_receiver_info(signer_token)
        send_request("get", "signature/receiver/info/#{signer_token}")
      end

      def fix_receiver_email(signer_token, new_email)
        body = {email: new_email}
        extracted_body = RequestPayload::FormUrlEncoded.new(body).extract_to_s
        send_request("put","signature/receiver/fix-email/#{signer_token}", body: extracted_body)
      end

      def fix_receiver_phone(signer_token, new_phone)
        body = {phone: new_phone}
        extracted_body = RequestPayload::FormUrlEncoded.new(body).extract_to_s
      send_request("put","signature/receiver/fix-phone/#{signer_token}", body: extracted_body)
      end

      private

      def download_file(url,directory,create_directory: true,filename:)
        if self.worker_server.nil?
          response = perform_start_request
          self.worker_server = "#{Servers::PROTOCOL}://" + response.body['server']
        end
        
        response = send_request("get",url)
        content_disposition = response.headers[:content_disposition]
        filename_to_set = ::File.basename(filename,::File.extname(filename)) unless filename.nil?
        external_filename = parse_filename_from_content_disposition(content_disposition)

        if filename_to_set.nil?
          filename_to_set = external_filename 
        else
          filename_to_set << ::File.extname(external_filename)
        end

        if directory
          directory = Pathname.new(directory).to_s if directory.is_a?(Pathname)
          directory.chop! if directory.end_with? '/'
        else
          directory = '.'
        end

        destination = "#{directory}/#{filename_to_set}"

        FileUtils.mkdir_p(directory) if create_directory
        ::File.open(destination, 'wb'){|file| file.write(response.raw_body) }
        destination
      end

      def parse_filename_from_content_disposition(content_disposition)
        if match_data = /filename\*\=utf-8\'\'([\W\w]+)/.match(content_disposition)
          filename_to_set = URI.unescape(match_data[1].gsub('"', ''))
        else
          match_data  = / .*filename=\"([\W\w]+)\"/.match(content_disposition)
          filename_to_set =  match_data[1].gsub('"', '')
        end
      end
    end
  end
end
