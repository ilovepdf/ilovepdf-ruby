require "spec_helper"

RSpec.describe Ilovepdf do
  subject { Ilovepdf::Ilovepdf.new('abcdef', 'ghijk') }

  it "has a version number" do
    expect(Ilovepdf::VERSION).not_to be nil
  end
  describe "#klass_error_for" do
    it "returns Ilovepdf::Errors::DownloadError" do
      error_klass = subject.send(:klass_error_for, 'download/abcd')
      expect(error_klass).to eq(Ilovepdf::Errors::DownloadError)
    end
    it "returns Ilovepdf::ApiError" do
      error_klass = subject.send(:klass_error_for, '1234')
      expect(error_klass).to eq(Ilovepdf::ApiError)
    end
  end
end
