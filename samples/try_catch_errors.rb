require "bundler/setup"
require 'ilovepdf'

begin
  # Get an instance of the task tool Split
  my_task = Ilovepdf::Tool::Split.new("PUBLIC_KEY", "SECRET_KEY");

  # File object keeps information about its server_filename and the properties you can set
  file = my_task.add_file '/path/to/file/document.pdf'
  # set ranges to split the document
  my_task.ranges = '2-4,6-8'

  # and set name for output file.
  # the task will set the correct file extension for you
  my_task.packaged_filename = 'split_documents'

  # and name for splitted document (inside the zip file)
  my_task.output_filename = 'split'
  my_task.execute
  my_task.download
rescue Ilovepdf::Errors::AuthError => e # Catch Auth errors
  puts "An error occurred on Auth: " + e.message
  # To examine more in depth what the server returned:
  # puts e.http_response.body
rescue Ilovepdf::Errors::StartError => e    # Catch API errors from Start endpoint
  puts "An error occurred on Start: " + e.message
  # To examine more in depth what the server returned:
  # puts e.http_response.body
rescue Ilovepdf::Errors::UploadError => e   # Catch API errors from Upload endpoint
  puts "An error occurred on Upload: " + e.message
  # To examine more in depth what the server returned:
  # puts e.http_response.body
rescue Ilovepdf::Errors::ProcessError => e  # Catch API errors from Process endpoint
  puts "An error occurred on Process: " + e.message
  # To examine more in depth what the server returned:
  # puts e.http_response.body
rescue Ilovepdf::ApiError => e
  puts "An error occurred on an API call to Ilovepdf: " + e.message
  # To examine more in depth what the server returned:
  # puts e.http_response.body
rescue Ilovepdf::Error => e # Catch library errors
  puts "An error occurred on the lib: " + e.message
rescue StandardError => e # Catch all errors
  puts "Something went wrong: #{e.message}"
end
