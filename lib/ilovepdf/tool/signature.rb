module Ilovepdf
  module Tool
    class Signature < ::Ilovepdf::Task
      using ::Ilovepdf::Refinements::Crush

      undef_method :next,:chained_task?,:enable_file_encryption,:download,
                      :delete!,:perform_filedownload_request, :assign_meta_value,
                      :perform_process_request, :ignore_password, :ignore_errors,
                      :try_pdf_repair, :packaged_filename, :output_filename

      API_PARAMS = [:brand_name,:brand_logo,
                      :language,:lock_order,
                      :message_signer,:subject_signer,:uuid_visible,:expiration_days,
                      :signer_reminders,:signer_reminder_days_cycle,:verify_enabled ]

      attr_accessor *API_PARAMS

      def initialize(public_key, secret_key, make_start=true)
        self.tool = :sign
        super(public_key, secret_key, make_start)
      end

      def execute
        @result = perform_process_request
      end

      def uuid_visible=(value)
        @uuid_visible = !!value
      end

      def brand_name=(value)
        raise ::Ilovepdf::Errors::UnsupportedFunctionalityError.new("Method not implemented")
      end

      def brand_logo=(value)
        raise ::Ilovepdf::Errors::UnsupportedFunctionalityError.new("Method not implemented")
      end

      def add_receiver(receiver)
        raise ::Ilovepdf::Errors::ArgumentError.new("value is not receiver") unless receiver.is_a?(Ilovepdf::Signature::Receiver)
        @signers << receiver
      end

      def language=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("value is not a string") unless value.is_a?(String)
        @language = value
      end

      def lock_order=(value)
        @lock_order = !!value ? "1" : "0"
      end

      def email_content(subject:,body:)
        @subject_signer = subject
        @message_signer = body
        {subject: @subject_signer,body: @message_signer}
      end

      def expiration_days=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("value is not an Integer") unless value.is_a?(Integer)
        @expiration_days = value
      end

      def reminders=(value)
        raise ::Ilovepdf::Errors::ArgumentError.new("value is not an Integer") unless value.is_a?(Integer)
        if(value <= 0)
          @signer_reminders = false
          @signer_reminder_days_cycle = nil
        else
          @signer_reminders = true
          @signer_reminder_days_cycle = value
        end
        value
      end

      def upload_brand_logo_file(logoPath)
        perform_upload_request(logoPath)
      end

      def upload_brand_logo_file_from_url(logoUrl)
        perform_upload_url_request(logoUrl)
      end

      def add_brand(name:,logo:)
        @brand_logo = logo.server_filename
        @brand_name = name
      end

      def verify_enabled=(value)
        @verify_enabled = !!value
      end

      def signers
        @signers ||= []
      end

      def <<(receiver)
        raise ::Ilovepdf::Errors::ArgumentError.new("value is not an Ilovepdf::Signature::Receive") unless receiver.is_a?(::Ilovepdf::Signature::Receiver)
        @signers ||= []
        @signers << receiver
      end

      def extract_api_params
        params = super
        params[:task] = task_id
        params[:files] = files.map do |file|
          {server_filename: file.server_filename,filename: file.filename}
        end
        params[:signers] = signers.map do |signer|
          {
            name: signer.name,
            email: signer.email,
            phone: signer.phone,
            files: signer.elements.group_by do |element|
              element.file.server_filename
            end.inject([]) do |result,(server_filename,elements)|
              result << {
                server_filename: server_filename,
                elements: elements.map(&:to_h)
              }
              result
            end,
            type: signer.type,
            access_code: signer.access_code,
            force_signature_type: signer.force_signature_type
          }
        end
        params.crush
      end

      def send_to_sign
        body = extract_api_params
        extracted_body = RequestPayload::FormUrlEncoded.new(body).extract_to_s
        response = send_request('post', 'signature', body: extracted_body)
        response
      end

    end
  end
end
