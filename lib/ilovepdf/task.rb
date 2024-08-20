module Ilovepdf
  class Task < Ilovepdf
    attr_accessor :task_id, :tool, :packaged_filename, :output_filename,
                  :ignore_errors, :ignore_password, :try_pdf_repair

    attr_reader :result

    API_PARAMS    = []
    DOWNLOAD_INFO = [:output_filename, :output_file, :output_filetype]

    def initialize(public_key, secret_key, make_start=false)
      super(public_key, secret_key)
      # Assign default values
      self.ignore_errors    = true
      self.ignore_password  = true
      self.try_pdf_repair   = true

      @chained_task = (make_start == false)
      if make_start
        response = perform_start_request
        self.worker_server = "#{Servers::PROTOCOL}://" + response.body['server']
        self.task_id       = response.body['task']
      end
    end

    def chained_task?
      @chained_task
    end

    def next(next_tool)
      body = {
        v: API_VERSION,
        task: self.task_id,
        tool: next_tool,
      }
      extracted_body = RequestPayload::FormUrlEncoded.new(body).extract_to_s

      begin
        response = send_request('post', "task/next", body: extracted_body)
        no_task_present = !response.body.key?('task') || response.body['task'].to_s.empty?
        raise StartError.new(response, custom_msg: "No task assigned on chained start") if no_task_present
      rescue ApiError => e
        raise StartError.new(e, custom_msg: "Error on start chained task")
      end

      next_task = self.new_task(next_tool)
      next_task.send(:"worker_server=", worker_server)
      next_task.send(:"task_id=", response.body['task'])

      response.body['files'].each do |server_filename, filename|
        next_task.files << File.new(server_filename, filename)
      end

      next_task
    end

    def assign_meta_value(key, value)
      meta_values[key] = value
    end

    def files
      @files ||= []
    end

    def add_file(filepath, extra_upload_params = nil)
      raise ArgumentError.new("No file exists in '#{filepath}'") unless ::File.exist?(filepath)
      file = perform_upload_request(filepath,extra_upload_params)
      files << file
      file
    end

    def add_file_from_url(url,extra_upload_params = nil)
      file = perform_upload_url_request(url,extra_upload_params)
      files << file
      file
    end

    def download(path=nil, create_directory: false)
      download_file

      if path
        path = Pathname.new(path).to_s if path.is_a?(Pathname)
        path.chop! if path.end_with? '/'
      else
        path = '.'
      end

      destination = "#{path}/#{download_info.output_filename}"
      FileUtils.mkdir_p(path) if create_directory
      ::File.open(destination, 'wb'){|file| file.write(download_info.output_file) }
      true
    end

    def blob
      download_file
      download_info.output_file
    end

    def download_info
      @download_info ||= Struct.new(*DOWNLOAD_INFO).new
    end

    # [API Methods] Actions on task

    def status
      http_response = query_task_status(worker_server,task_id)
    end

    def execute
      @result = perform_process_request
    end

    def delete!
      send_request('delete', 'task/' + self.task_id)
    end

    def delete_file(file)
      raise Error.new("File was already deleted") if file.deleted?
      file_was_found = files.find{|f| f.server_filename == file.server_filename }
      raise Error.new("File to delete not found") if !file_was_found
      response = perform_deletefile_request(file)
      if response.success?
        file.mark_as_deleted
        new_files = files.reject{|f| f.server_filename == file.server_filename }
        send(:files=, new_files)
      else
        raise ApiError.new(response, custom_msg: "No error ocurred but response was not successful when deleting the desired file")
      end
      true
    end

    def enable_file_encryption(enable, new_encrypt_key = nil)
      raise Error.new("Encryption mode cannot be assigned after uploading the files") if files.size > 0
      super(enable, new_encrypt_key)
    end

    private

    # set meta values as http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/pdf_reference_1-7.pdf (page 844)
    def meta_values
      @meta_values ||= {}
    end

    def files=(new_array_of_files)
      @files = new_array_of_files
    end

    def download_file
      response = perform_filedownload_request
      content_disposition = response.headers[:content_disposition]

      if match_data = /filename\*\=utf-8\'\'([\W\w]+)/.match(content_disposition)
        filename = URI.decode_www_form_component(match_data[1].gsub('"', ''))
      else
        match_data  = / .*filename=\"([\W\w]+)\"/.match(content_disposition)
        filename =  match_data[1].gsub('"', '')
      end

      download_info.output_filename  = filename
      download_info.output_file      = response.raw_body
      download_info.output_filetype  = ::File.extname(filename)
      true
    end

    # [HTTP request methods]
    def perform_deletefile_request(file)
      body = {
        task: self.task_id,
        server_filename: file.server_filename,
        v: API_VERSION
      }
      response = send_request('delete', "upload/#{self.task_id}/#{file.server_filename}", body: body)
    end

    def perform_filedownload_request
      response = send_request('get', 'download/' + self.task_id, body: {v: API_VERSION})
    end

    def perform_process_request
      body = {
        task: self.task_id,
        tool: self.tool,
        packaged_filename: self.packaged_filename,
        output_filename: self.output_filename,
        ignore_errors: self.ignore_errors,
        ignore_password: self.ignore_password,
        try_pdf_repair: self.try_pdf_repair,
        meta: meta_values,
        v: API_VERSION,
      }.merge(file_submit_params)
      .merge(extract_api_params)


      extracted_body = RequestPayload::FormUrlEncoded.new(body).extract_to_s

      response = send_request('post', 'process', body: body)
      response
    end

    def perform_start_request
      body = {
        v: API_VERSION
      }
      extracted_body = RequestPayload::FormUrlEncoded.new(body).extract_to_s
      response = send_request('get', "start/#{self.tool}", body: extracted_body)
      is_server_defined = response.body.key?('server') && !response.body['server'].to_s.empty?
      raise ::Ilovepdf::Errors::StartError.new("No server assigned on start") if !is_server_defined
      
      response
    end

    def perform_upload_request filepath, tool_additional_params = nil
      request_opts = {
        body: {
          multipart: true,
          v: API_VERSION,
          task: self.task_id,
          file: ::File.new(filepath, 'rb')
        }
      }
      if tool_additional_params.is_a?(::Ilovepdf::ExtraUploadParams::Base)
        request_opts[:body].merge!(tool_additional_params.extra_params.transform_keys(&:to_sym))
      end
      
      # filepath
      response = send_request('post', 'upload', request_opts)
      self.get_file_from_response(response.body,filepath)
    end

    def perform_upload_url_request url,tool_additional_params = nil
      request_opts = {
        body: {
          multipart: true,
          v: API_VERSION,
          task: self.task_id,
          cloud_file: url
        }
      }
      if tool_additional_params.is_a?(::Ilovepdf::ExtraUploadParams::Base)
        request_opts[:body].merge!(tool_additional_params.extra_params.transform_keys(&:to_sym))
      end
      response = send_request('post', 'upload', request_opts)
      self.get_file_from_response(response.body,url)
    end

    def file_submit_params
      h = {files:{}}
      files.each_with_index do |f, i|
        h[:files][i.to_s] = f.file_options
      end
      h
    end

    def extract_api_param_value(param_name)
      send(param_name)
    end

    def extract_api_params
      self.class::API_PARAMS.inject({}) do |result,param_name|
        result[param_name] = extract_api_param_value(param_name)
        result
      end
    end

    private 

    def get_file_from_response(response_body,filePathOrUrl)
      file = File.new(response_body['server_filename'], Pathname.new(filePathOrUrl).basename.to_s)
      if response_body['pdf_pages'] 
        file.pdf_pages =  response_body['pdf_pages']
      end
      if response_body['pdf_page_number'] 
        file.pdf_page_number =  response_body['pdf_page_number'].to_i
      end
      if response_body['pdf_forms'] 
        file.pdf_forms =  response_body['pdf_forms']
      end
      file
    end
  end
end
