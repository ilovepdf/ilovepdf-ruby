require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
my_task = Ilovepdf::Tool::Rotate.new("PUBLIC_KEY", "SECRET_KEY");

# File object keeps information about its server_filename and the properties you can set
file = my_task.add_file '/path/to/file/document.pdf'

# We can rotate a file
file.rotate = 90;

# and set name for output file.
# the task will set the correct file extension for you
my_task.output_filename = 'rotated_file'

# Finally is time to process the files. i.e We'll send them to Ilovepdf servers :)
response = my_task.execute

# and finally download the file. If no path is set, it will be downloaded on your current working directory
my_task.download('path/to/download')
