require "spec_helper"

RSpec.describe Ilovepdf::RequestPayload::FormUrlEncoded do
  let(:simple_payload){ 
    {v: '6', test: 4  } 
  }

  let(:compound_payload){ 
    {
      v: '6', 
      test: 4, 
      elements: [
        {a: 3, b: "test19"},
        {xy: true, xz: "test34"}
      ] 
    } 
  }

  let(:nested_compound_payload){ 
    {
      v: '6', 
      test: 4,
      elements: [
        {
          a: 3, 
          b: "test19",
          c: [{d: 4}, {}, {e: 'red'}, [], {}, {f: [{g:9}]}]
        },
        {xy: true, xz: "test34"}
      ] 
    } 
  }

  let(:complex_payload){
    {
      nil_prop: nil,
      empty_str: "",
      custom_array: [nil,'not_empty_array_item', nil, {key_in_array: 123}, nil, "", nil],
      empty_array: []
    }
  }

  describe "#extract_to_s" do
    it "outputs correct url-encoded string for complex payload" do
      payload_instance = Ilovepdf::RequestPayload::FormUrlEncoded.new(complex_payload)
      components = [
        "empty_str=",
        "custom_array[1]=not_empty_array_item",
        "custom_array[3][key_in_array]=123",
        "custom_array[5]="
      ]
      expect(payload_instance.extract_to_s).to eq(components.join("&"))
    end

    it "outputs correct url-encoded string for simple payload" do
      payload_instance = Ilovepdf::RequestPayload::FormUrlEncoded.new(simple_payload)
      expect(payload_instance.extract_to_s).to eq('v=6&test=4')
    end
    it "outputs correct url-encoded string for compound payload" do
      payload_instance = Ilovepdf::RequestPayload::FormUrlEncoded.new(compound_payload)
      expect(payload_instance.extract_to_s).to eq('v=6&test=4&elements[0][a]=3&elements[0][b]=test19&elements[1][xy]=true&elements[1][xz]=test34')
    end
    it "outputs correct url-encoded string for nested compound payload" do
      payload_instance = Ilovepdf::RequestPayload::FormUrlEncoded.new(nested_compound_payload)
      expected_str = "v=6&test=4&elements[0][a]=3&elements[0][b]=test19&elements[0][c][0][d]=4&elements[0][c][2][e]=red&elements[0][c][5][f][0][g]=9&elements[1][xy]=true&elements[1][xz]=test34"
      expect(payload_instance.extract_to_s).to eq(expected_str)
    end
    it "outputs empty string" do
      payload_instance = Ilovepdf::RequestPayload::FormUrlEncoded.new({})
      expect(payload_instance.extract_to_s).to eq("")
    end
    it "does not output 'meta' (hash)" do
      payload_instance = Ilovepdf::RequestPayload::FormUrlEncoded.new({meta: {}})
      expect(payload_instance.extract_to_s).to eq("")
    end
    it "does not output 'meta' (array)" do
      payload_instance = Ilovepdf::RequestPayload::FormUrlEncoded.new({meta: []})
      expect(payload_instance.extract_to_s).to eq("")
    end
  end
end
