require "bundler/setup"
require 'ilovepdf'

# Start the manager class
ilovepdf = Ilovepdf::Ilovepdf.new("PUBLIC_KEY", "SECRET_KEY");

# and get the task tool
my_task = ilovepdf.new_task :repair

# File object keeps information about its server_filename and the properties you can set
file = my_task.add_file '/path/to/file/document_a.pdf'

# Process files
response = my_task.execute

# and finally download the file. If no path is set, it will be downloaded on your current working directory
my_task.download 'path/to/download'
