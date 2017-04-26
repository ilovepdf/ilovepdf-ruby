require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
my_task = Ilovepdf::Tool::Compress.new("PUBLIC_KEY", "SECRET_KEY");

# File object keeps information about its server_filename and the properties you can set
file = my_task.add_file '/path/to/file/document.pdf'

# We can rotate a file
file.rotate = 90

# Set compression level
my_task.compression_level = 'extreme'

# and set name for output file.
# the task will set the correct file extension for you
my_task.output_filename = 'lowlow_compression'

# Finally is time to process the files. i.e We'll send them to Ilovepdf servers :)
response = my_task.execute
puts "Time spent doing processing the task: #{response.body['timer']}" # You can check the time spent processing the task

# and finally download the file. If no path is set, it will be downloaded on your current working directory
my_task.download 'path/to/download'
