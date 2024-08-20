require "bundler/setup"
require 'ilovepdf'

# You can call task class directly
pub_key = "YOUR_PUBLIC_KEY"
priv_key = "YOUR_PRIVATE_KEY"
my_task = Ilovepdf::Tool::Signature.new(pub_key, priv_key)

# Send additional parameters to obtain the information about the PDF and the information about the form elements
extra_params = Ilovepdf::ExtraUploadParams::Signature.new
extra_params.set_pdf_forms(true).set_pdf_info(true)
file  = my_task.add_file('/path/to/file/sample.pdf',extra_params)

# Define the signer
signer = Ilovepdf::Signature::Receiver.new(:signer,'name','email@email.com')

# Get number of pages
file.pdf_page_number
# get specific pdf page
pdf_page = file.pdf_page_info(1)
puts pdf_page.width
puts pdf_page.height

# Now we can loop over all of the form elements on the PDF
file.each_pdf_form_element do |form_element, pdf_page_info|
  type_of_field = form_element["typeOfField"]
  next unless ["textbox", "signature"].include?(type_of_field)

  field_id = form_element["fieldId"]
  widgets = form_element["widgetsInformation"]
  position = widgets[0]
  current_page = position["page"]

  left_pos = position["left"]
  top_position = position["top"] - pdf_page_info["height"]
  size = (position["left"] - position["bottom"]).floor

  if type_of_field == "textbox"
    if form_element["multilineFlag"] || form_element["passwordFlag"]
      next
    end

    text_value = form_element["textValue"]
    # For instance, we want to create an input element if the label of the form contains the word "Input".
    if field_id.include?('_input')
      input_element = ElementInput.new
      input_element.set_position(left_pos, top_position)
                   .set_size(size)
                   .set_label(text_value)
                   .set_pages(current_page.to_s)
      elements << input_element
    else
      text_element = ElementText.new
      text_element.set_position(left_pos, top_position)
                  .set_size(size)
                  .set_text(text_value)
                  .set_pages(current_page.to_s)
      elements << text_element
    end
  elsif type_of_field == "signature"
    signature_element = ElementSignature.new
    signature_element.set_position(left_pos, top_position)
                     .set_size(size)
    elements << signature_element
  end
end

 