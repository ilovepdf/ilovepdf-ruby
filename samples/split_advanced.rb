require "bundler/setup"
require 'ilovepdf'

# Start the manager class
ilovepdf = Ilovepdf::Ilovepdf.new("PUBLIC_KEY", "SECRET_KEY");

# and get the task tool
my_task = ilovepdf.new_task :split

# or you can call task class directly, this set the same tool as before
my_task = Ilovepdf::Tool::Split.new("PUBLIC_KEY", "SECRET_KEY");


# File object keeps information about its server_filename and the properties you can set
file = my_task.add_file '/path/to/file/document.pdf'

# set ranges to split the document
my_task.ranges = "2-4,6-8"

# and set name for output file.
# the task will set the correct file extension for you
my_task.packaged_filename = 'split_documents'

# and name for splitted document (inside the zip file)
my_task.output_filename = 'split'

# Finally is time to process the files. i.e We'll send them to Ilovepdf servers :)
response = my_task.execute
puts "Time spent doing processing the task: #{response.body['timer']}" # You can check the time spent processing the task

# and finally download the file. If no path is set, it will be downloaded on your current working directory
my_task.download 'path/to/download'
