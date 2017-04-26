require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
my_task = Ilovepdf::Tool::Watermark.new("PUBLIC_KEY", "SECRET_KEY");

# File object keeps information about its server_filename and the properties you can set
file = my_task.add_file '/path/to/file/document.pdf'

# set mode to text
my_task.mode = "text"

# set the text
my_task.text = "watermark text"

# Finally is time to process the files. i.e We'll send them to Ilovepdf servers :)
my_task.execute

# and finally download the file. If no path is set, it will be downloaded on your current working directory
my_task.download 'path/to/download'
