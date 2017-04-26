require "spec_helper"

RSpec.describe Ilovepdf::Ilovepdf do
  subject { Ilovepdf::Ilovepdf.new('abcdef', 'ghijk') }

  before(:all) do

  end

  it "sets api keys correctly" do
    expect(subject.instance_variable_get(:@public_key)).to eq('abcdef')
    expect(subject.instance_variable_get(:@secret_key)).to eq('ghijk')
  end
  describe "#jwt" do
    it "raises an error if no api keys found" do
      subject.instance_variable_set(:@public_key, nil)
      subject.instance_variable_set(:@secret_key, nil)
      expect{ subject.send(:jwt) }.to raise_error(Ilovepdf::Error)
    end
  end
  describe "#new_task" do
    it "raises an error when a not-found task is passed as argument" do
      expect{ subject.new_task(:not_found) }.to raise_error(Ilovepdf::Error)
    end
  end
  describe "::all_tool_names" do
    it "returns 12 available tools to use" do
      expect(Ilovepdf::Ilovepdf.all_tool_names.count).to eq(12)
    end
  end
end
