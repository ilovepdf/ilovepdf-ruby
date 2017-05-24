require "spec_helper"

RSpec.describe Ilovepdf::Tool::ValidatePdfa do
  subject { Ilovepdf::Tool::ValidatePdfa.new('abcdef', 'ghijk') }

  describe "downloads the file" do
    it "it raises an error since this operation is not supported" do
      subject.add_file(::Ilovepdf::RSpec.sample_pdf_filepath)
      response = subject.execute
      expect{ subject.download }.to raise_error(::Ilovepdf::Errors::UnsupportedFunctionalityError)
    end
  end
end
