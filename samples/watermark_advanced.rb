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

# set pages to apply the watermark
my_task.pages = "1-5,7"

# set vertical position
my_task.vertical_position = "top"

# set horizontal position
my_task.horizontal_position = 'right'

# adjust vertical position
my_task.vertical_position_adjustment = "100"

# adjust horizontal position
my_task.horizontal_position_adjustment = "100"

# set mode to text
my_task.font_family = "Arial"

# set mode to text
my_task.font_style = "italic"

# set the font size
my_task.font_size = "12"

# set color to red
my_task.font_color = "#ff0000"

# set transparency
my_task.transparency = "50"

# set the layer
my_task.layer = "below"

# and set name for output file.
# the task will set the correct file extension for you
my_task.output_filename = 'watermarked'

# Finally is time to process the files. i.e We'll send them to Ilovepdf servers :)
my_task.execute

# and finally download the file. If no path is set, it will be downloaded on your current working directory
my_task.download 'path/to/download'
