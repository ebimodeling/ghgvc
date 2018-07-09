require "rails_helper"

RSpec.describe Biome do
  it do
    expect(Biome.list(33.43, -96.07)).to be_truthy
  end
end
