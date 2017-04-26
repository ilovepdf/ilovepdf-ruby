require "spec_helper"

RSpec.describe Ilovepdf::Task do
  subject { Ilovepdf::Task.new('abcdef', 'ghijk') }
  describe "#new_task" do
    it "creates a :compress task successfully" do
      expect{ subject.new_task(:compress) }.not_to raise_error
    end
    it "raises a Errors::AuthError when server returns 401" do
      start_regexp = ::Ilovepdf::RSpec::ENDPOINTS_URI_REGEXP[:start]
      stub_request(:any, start_regexp).to_return do |req|
        {status: 401}
      end
      expect{ task = subject.new_task :compress }.to raise_error(Ilovepdf::Errors::AuthError)
    end
  end
  describe "#add_file" do
    it "raises an error when file does not exist" do
      expect{ subject.add_file('/file/to/lost/path.pdf') }.to raise_error(ArgumentError)
    end
    it "adds a new file successfully" do
      expect{ subject.add_file(::Ilovepdf::RSpec.sample_pdf_filepath) }.not_to raise_error
    end
    it "adds a new file in the files array" do
      expect{ subject.add_file(::Ilovepdf::RSpec.sample_pdf_filepath) }.to change{subject.files.size}.by(1)
    end
  end
  describe "#add_file_from_url" do
    it "adds a new file from url successfully" do
      expect{ subject.add_file_from_url("http://127.0.0.1.com/some/pdf") }.not_to raise_error
    end
  end
  describe "#file_submit_params" do
    it "returns a well-formed hash" do
      subject.files << Ilovepdf::File.new('abc', 'fgh')
      subject.files << Ilovepdf::File.new('123', '456')
      h = subject.send(:file_submit_params)
      expect(h.has_key?(:files)).to eq(true)

      expect(h[:files].keys.all?{|k| ['0', '1'].include?(k)}).to eq(true)
    end
  end
end
