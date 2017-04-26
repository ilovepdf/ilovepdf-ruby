require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
my_task = Ilovepdf::Tool::Unlock.new("PUBLIC_KEY", "SECRET_KEY");

# File object keeps information about its server_filename and the properties you can set
file = my_task.add_file '/path/to/file/document.pdf'

# set the current password of the locked PDF you want to unlock
file.password = 'test'

# Finally is time to process the files. i.e We'll send them to Ilovepdf servers :)
my_task.execute

# and finally download the file. If no path is set, it will be downloaded on your current working directory
my_task.download 'path/to/download'
