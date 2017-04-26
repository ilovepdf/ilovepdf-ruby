require "spec_helper"

RSpec.describe Ilovepdf::File do
  subject { Ilovepdf::File.new('abcdef', 'ghijk') }

  describe "#rotate=" do
    it "assigns a rotation to the file" do
      subject.rotate =  90
      expect(subject.rotate).to eq(90)
    end
    it "raises an error when value is a string" do
      expect{ subject.rotate= '90' }.to raise_error(Ilovepdf::Errors::ArgumentEnumError)
    end
    it "raises an error when value is not a valid rotation degree" do
      expect{ subject.rotate= 91 }.to raise_error(Ilovepdf::Errors::ArgumentEnumError)
    end
  end
  describe "#file_options" do

  end
  describe "#mark_as_deleted" do
    it "returns true to deleted? when mark_as_deleted is called" do
      subject.mark_as_deleted
      expect(subject.deleted?).to eq(true)
    end
    it "returns false when mark_as_deleted is not called" do
      expect(subject.deleted?).to eq(false)
    end
  end
end
