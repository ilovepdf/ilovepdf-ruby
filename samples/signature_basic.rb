require "bundler/setup"
require 'ilovepdf'

# You can call task class directly

my_task = Ilovepdf::Tool::Signature.new(pub_key, priv_key)
# File object keeps information about its server_filename and the properties you can set
file  = my_task.add_file '/path/to/file/sample.pdf'

signer = Ilovepdf::Signature::Receiver.new(:signer,'name','email@email.com')

signature_element = Ilovepdf::Signature::SignatureElement.new(file)
signature_element.set_position(x: 20,y: -20)
signature_element.pages = "1"
signature_element.size = 40

signer << signature_element

my_task << signer

body = my_task.send_to_sign.body
