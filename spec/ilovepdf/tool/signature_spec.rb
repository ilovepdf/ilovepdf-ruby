require "spec_helper"

RSpec.describe Ilovepdf::Tool::Signature do
  subject { Ilovepdf::Tool::Signature.new('abcdef', 'ghijk') }

  describe "#create" do
    it "creates a simple" do
      file = subject.add_file(::Ilovepdf::RSpec.sample_pdf_filepath)
      signer = Ilovepdf::Signature::Receiver.new(:signer,'name','email@email.com')
      signature_element = Ilovepdf::Signature::SignatureElement.new(file)
      signature_element.set_position(x: 20,y: -20)
      signature_element.pages = "1"
      signature_element.size = 40

      signer << signature_element
      body = subject.send_to_sign.body
    end
  end
end
