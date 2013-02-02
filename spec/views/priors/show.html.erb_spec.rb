require 'spec_helper'

describe "priors/show" do
  before(:each) do
    @prior = assign(:prior, stub_model(Prior,
      :citation_id => 1,
      :variable_id => "Variable",
      :phylogeny => "Phylogeny",
      :distn => "Distn",
      :parama => "9.99",
      :paramb => "9.99",
      :paramc => "9.99",
      :n => 2,
      :notes => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Variable/)
    rendered.should match(/Phylogeny/)
    rendered.should match(/Distn/)
    rendered.should match(/9.99/)
    rendered.should match(/9.99/)
    rendered.should match(/9.99/)
    rendered.should match(/2/)
    rendered.should match(/MyText/)
  end
end
