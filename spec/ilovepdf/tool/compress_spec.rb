require "spec_helper"

RSpec.describe Ilovepdf::Tool::Compress do
  subject { Ilovepdf::Tool::Compress.new('abcdef', 'ghijk') }

  describe "#compression_level" do
    it "raises an error when assigning an invalid value" do
      expect{subject.compression_level = 'unknown'}.to raise_error(Ilovepdf::Errors::ArgumentEnumError)
    end
    it "assigns the value correctly when value is valid" do
      expect{subject.compression_level = 'extreme'}.not_to raise_error
    end
  end
  describe "downloads the file" do
    it "asdasd" do
      subject.add_file(::Ilovepdf::RSpec.sample_pdf_filepath)
      response = subject.execute
      subject.download
    end
  end
end
