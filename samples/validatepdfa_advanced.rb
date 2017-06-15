require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
my_task = Ilovepdf::Tool::ValidatePdfa.new("PUBLIC_KEY", "SECRET_KEY");

# File object keeps information about its server_filename and the properties you can set
file = my_task.add_file '/path/to/file/document.pdf'

file.conformance = 'pdfa-2a'

# Finally is time to process the files. i.e We'll send them to Ilovepdf servers :)
response = my_task.execute

response.body['validations'].each do |results|
  file = my_task.files.find{|file| file.server_filename == results['server_filename']}
  puts "File with name '#{file.filename}' has the following status: #{results['status']}"
end
