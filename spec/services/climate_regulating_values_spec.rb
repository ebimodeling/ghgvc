require "rails_helper"
require "json"

RSpec.describe ClimateRegulatingValues do
  let(:json_hash_1) { JSON.parse(file_fixture("sample_1.json").read).to_h }
  let(:json_hash_2) { JSON.parse(file_fixture("sample_2.json").read).to_h }

  it "example 1" do
    expect(ClimateRegulatingValues.calculate(json_hash_1)).to be_truthy
  end

  it "example 2" do
    expect(ClimateRegulatingValues.calculate(json_hash_2)).to be_truthy
  end
end
