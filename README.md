iLovePDF Api - Ruby Library
--------------------------
[![Build Status](https://travis-ci.org/ilovepdf/ilovepdf-php.svg?branch=master)](https://travis-ci.org/ilovepdf/ilovepdf-php)
[![GitHub version](https://badge.fury.io/gh/ilovepdf%2Filovepdf-ruby.svg)](https://badge.fury.io/gh/ilovepdf%2Filovepdf-ruby)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A library in ruby for [iLovePDF Api](https://developer.ilovepdf.com)

You can sign up for a iLovePDF account at https://developer.ilovepdf.com

Develop and automate PDF processing tasks like: 

* Compress PDF
* Merge PDF
* Split PDF
* Convert Office to PDF
* PDF to JPG
* Images to PDF
* Add Page Numbers
* Rotate PDF
* Unlock PDF
* Protect PDF
* Stamp a Watermark
* Repair PDF
* PDF to PDF/A
* Validate PDF/A
* Extract

Each one with several settings to get your desired results.

## Requirements
Ruby 2.3 or greater

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ilovepdf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ilovepdf

## Usage

### Getting started
The quickest way to get started is to first get a set of [API keys here](https://developer.ilovepdf.com/)
and run the following code snippet:

```ruby
public_key  = 'YOUR_PUBLIC_KEY'
private_key = 'YOUR_PRIVATE_KEY'
ilovepdf = Ilovepdf::Ilovepdf.new(public_key, private_key)
# Create a task with the tool you want to use:
task = ilovepdf.new_task :compress
# Add the files you want to upload...
file1 = task.add_file 'my_disk/my_example1.pdf'
file2 = task.add_file 'my_disk/my_example2.pdf'
file3 = task.add_file_from_url 'http://URL_TO_PDF'
# Once you are done uploading your files:
task.execute
task.download
```
That's it!

For a more in-depth usage, refer to the [sample codes](https://github.com/ilovepdf/ilovepdf-ruby/tree/master/samples) in this repository.

## Documentation
### HTTP API Calls
All PDF tools have the following methods that contact with the iLovePDF API:

| Method                  | Description                                               | Notes                         |
| ------------------------|-----------------------------------------------------------|-------------------------------|
| add_file(file)          | Uploads a file to iLovepdf servers                        | Returns boolean               |
| add_file_from_url(url)  | Uploads a file to iLovepdf servers using a URL            | Returns boolean               |
| delete_file(file)       | Deletes a file from ilovepdf                              | Returns boolean               |
| download(filepath)      | Downloads the processed file                              | Returns boolean; No need to specify a filepath|
| status                  | Retrieves the current status of the task being processed  | Returns Ilovepdf::Response    |
| execute                 | Sends a request to Ilovepdf to begin processing the PDFs  | Returns Ilovepdf::Response    |
| delete!                 | Deletes the task                                          | Returns Ilovepdf::Response    |

Example:
```ruby
imagepdf_task = Ilovepdf::Tool::Imagepdf.new(public_key, secret_key)
http_response = imagepdf_task.execute
puts http_response.body
if imagepdf_task.download
  puts "Your file was downloaded successfully!"
end
```

### Methods common to all tools
| Method                                | Description                                               | Notes                                       |
| --------------------------------------|-----------------------------------------------------------|---------------------------------------------|
| enable_file_encryption(boolean, key)  | The key will be used to decrypt the files before processing and re-encrypt them after processing        | If no key provided, a random key is assigned (default: false) |
| assign_meta_value(key, value)         | [More info](https://developer.ilovepdf.com/docs/api-reference)      |                                   |
| ignore_errors                         | [More info](https://developer.ilovepdf.com/docs/api-reference)      | (default: true)                   |
| ignore_password                       | [More info](https://developer.ilovepdf.com/docs/api-reference)      | (default: true)                   |
| try_pdf_repair                        | When a PDF to process fails we try to repair it automatically       | (default: true)                   |
| packaged_filename                     | This allows you to specify the filename of the compressed file in case there is more than 1 file to be downloaded | |
| output_filename                       | The final name of the processed file                                |                                   |

#### Methods to query after performing the **execute** API method:
* result: It has stored the last **Ilovepdf::Response**

#### Methods to query after performing the **download** API method:
* download_info: Returns a [struct](https://ruby-doc.org/core-2.2.0/Struct.html) with the following info
  * :output_filename
  * :output_file
  * :output_filetype

### Tool attributes

All tools have specific attributes you can access and modify.
If you need want to know which params are available for a specific tool via the code, you can by looking at the **API_PARAMS** of that particular tool.
For example for the **Image to PDF** tool:
```ruby
puts Ilovepdf::Tool::Imagepdf::API_PARAMS
# => [:orientation, :margin, :pagesize]
```

To instantiate a Compress tool task directly do:
```ruby
compress_task = Ilovepdf::Tool::Compress.new(public_key, secret_key)
```

### Handling errors

Whenever there is an API Error in one of the endpoints, you can try to capture it the following way:

```ruby
begin
  compress_task = Ilovepdf::Tool::Compress.new(public_key, secret_key)
  compress_task.execute # Oops, this raises an error! I forgot to upload a file!
  compress_taks.download
rescue Ilovepdf::ApiError => e
  # Let's check what went wrong with the API call:
  puts e.http_response.body
end
```

For a more complete example of error handling check [samples/try_catch_errors.rb](https://github.com/ilovepdf/ilovepdf-ruby/blob/master/samples/try_catch_errors.rb)

Please see https://developer.ilovepdf.com/docs for up-to-date documentation.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
