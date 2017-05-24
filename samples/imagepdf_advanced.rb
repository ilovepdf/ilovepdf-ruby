require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
my_task = Ilovepdf::Tool::Imagepdf.new("PUBLIC_KEY", "SECRET_KEY");

# File object keeps information about its server_filename and the properties you can set
file  = my_task.add_file '/path/to/file/photo.png'
file2 = my_task.add_file '/path/to/file/image.tiff'

# Merge After: Default is true. If it is false then it will download a zip file with a pdf for each image
my_task.merge_after = false

# and set name for output file.
# the task will set the correct file extension for you.
my_task.output_filename = 'pdf_filename'

# and name for splitted document (inside the zip file)
my_task.packaged_filename = 'zip_filename'

# Process files
response = my_task.execute

# and finally download the file. If no path is set, it will be downloaded on your current working directory
my_task.download
