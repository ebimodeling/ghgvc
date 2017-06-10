require "rails_helper"
require "json"

RSpec.describe ClimateRegulatingValues do
  let(:json_hash) { JSON.parse(file_fixture("sample_1.json").read).to_h }

  it do
    expect(ClimateRegulatingValues.calculate(json_hash)).to be_truthy
  end
end
