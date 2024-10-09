require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
pub_key = "YOUR_PUBLIC_KEY"
priv_key = "YOUR_PRIVATE_KEY"

my_task = Ilovepdf::Tool::Signature.new(pub_key, priv_key)
# Upload brand logo
brand_logo = my_task.upload_brand_logo_file("/path/to/logo/logo.png")
my_task.add_brand(name: "my company name",logo: brand_logo)
my_task.language = "es"
my_task.lock_order = false # if false, allows receivers of signer type to sign in parallel.
                           # if true receivers of signer type must sign sequentially in order.
my_task.email_content(subject: "Subject of the first email", content: "content of the first email")
my_task.expiration_days = 55 # Number of days when it is going to expire the signature
my_task.reminders = 2 # Send reminders every 2 days.
my_task.verify_enabled = true # Add the QR code on the audit trail.
my_task.uuid_visible = true #Add uuid at the bottom of each signature. We highly recommend to leave the uuid_visible to true (the default value), otherwise it lowers the signature validity.


# File object keeps information about its server_filename and the properties you can set
file1  = my_task.add_file '/path/to/file/sample.pdf'
file2  = my_task.add_file '/path/to/file/sample2.pdf'

signer = Ilovepdf::Signature::Receiver.new(:signer,'name','email@email.com')
signer.phone = "34677231431" #Phone number with the country prefix at the beginning => "+34677231431", make sure you have enough credits.

signature_element = Ilovepdf::Signature::SignatureElement.new(file1)
signature_element.set_position(x: 20,y: -20)
signature_element.pages = "1,2"
signature_element.size = 40
signer << signature_element

date_element = Ilovepdf::Signature::DateElement.new(file1)
date_element.set_position(x: 30,y: -40)
date_element.pages = "1-3"
date_element.size = 10
signer << date_element

initials_element = Ilovepdf::Signature::InitialsElement.new(file1)
initials_element.set_position(x: 20,y: -20)
initials_element.pages = "1,2"
initials_element.size = 40
signer << initials_element

input_element = Ilovepdf::Signature::InputElement.new(file2,"Input your ID Number", "Please, fill in your ID Number")
input_element.set_position(x: 20,y: -20)
input_element.pages = "1-3,4-10"
input_element.size = 30
signer << initials_element

name_element = Ilovepdf::Signature::NameElement.new(file1)
name_element.set_position(x: 300,y: -200)
name_element.pages = "3-5,6-10"
name_element.size = 40
signer << initials_element

text_element = Ilovepdf::Signature::TextElement.new(file2,"This is a text field")
text_element.set_position(x: 20,y: -20)
text_element.pages = "1"
text_element.size = 40
signer << text_element

my_task.add_receiver(signer) # << is an alias of add_receiver

witness = Ilovepdf::Signature::Receiver.new(:witness,'name2','email2@email.com')
my_task << witness

validator = Ilovepdf::Signature::Receiver.new(:validator,'name3','email3@email.com')
my_task << validator

body = my_task.send_to_sign.body
token = body["token_requester"]

