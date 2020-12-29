require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
my_task = Ilovepdf::Tool::Split.new("PUBLIC_KEY", "SECRET_KEY");

# File object keeps information about its server_filename and the properties you can set
file = my_task.add_file '/path/to/file/document.pdf'

# get the 2nd page
$splitTask.ranges = "2";

# Process files
response = my_task.execute

# and create a new task from last action
chained_task = my_task.next(:pdfjpg)

chained_task.execute
chained_task.download