require "bundler/setup"
require 'ilovepdf'

# You can call task class directly

signature_management = Ilovepdf::Signature::Management.new(pub_key, priv_key)

signature_token = "SIGNATURE_TOKEN"
receiver_token = "SIGNATURE_TOKEN"

# Get information about a single signature request
status_response = signature_management.get_status(signature_token).body

# list all of the signatures
list = signature_management.list_signatures(current_page: 0,per_page: 20).body

#Download the audit pdf of a signature request, just pass the file name, the program is going to put the file extension accordingly
path = signature_management.download_audit(signature_token,"/tmp/",{create_directory: true, filename: "audit"})

# Download the original file, the resulting file can be either a ".pdf" if only one file was used for that request or a ".zip" otherwise
path = signature_management.download_original(signature_token,"/tmp/",{create_directory: true, filename: "original"})

# Download the signed file, the resulting file can be either a ".pdf" if only one file was used for that request or a ".zip" otherwise
path = signature_management.download_signed(signature_token,"/tmp/",{create_directory: true, filename: "signed"})

# Send reminders to the receivers that did not yet performed his action
signature_management.send_reminders(signature_token)

# Void the signature
signature_management.void_signature(signature_token)

# Increase the expiration days by 3
signature_management.void_signature(signature_token, 3)

# Get info of a receiver
receiver_response = signature_management.get_receiver_info(signer_token).body

# Fix receiver email
receiver_response = signature_management.fix_receiver_email(signer_token,"newemail@email.com").body

# Fix receiver email
receiver_response = signature_management.fix_receiver_phone(signer_token,"34639000000").body
