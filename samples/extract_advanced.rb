require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
my_task = Ilovepdf::Tool::Extract.new("PUBLIC_KEY", "SECRET_KEY");

# File object keeps information about its server_filename and the properties you can set
file = my_task.add_file '/path/to/file/document.pdf'

# By setting this parameter to true,
# we'll have detailed contents extraction into a CSV-formatted file
my_task.detailed = true

# and set name for output file.
# the task will set the correct file extension for you.
my_task.output_filename = 'csv_filename'

# Process files
response = my_task.execute

# and finally download the file. If no path is set, it will be downloaded on your current working directory
# It will download a text file with Linux line endings
my_task.download
