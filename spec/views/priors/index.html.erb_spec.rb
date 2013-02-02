require 'spec_helper'

describe "priors/index" do
  before(:each) do
    assign(:priors, [
      stub_model(Prior,
        :citation_id => 1,
        :variable_id => "Variable",
        :phylogeny => "Phylogeny",
        :distn => "Distn",
        :parama => "9.99",
        :paramb => "9.99",
        :paramc => "9.99",
        :n => 2,
        :notes => "MyText"
      ),
      stub_model(Prior,
        :citation_id => 1,
        :variable_id => "Variable",
        :phylogeny => "Phylogeny",
        :distn => "Distn",
        :parama => "9.99",
        :paramb => "9.99",
        :paramc => "9.99",
        :n => 2,
        :notes => "MyText"
      )
    ])
  end

  it "renders a list of priors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Variable".to_s, :count => 2
    assert_select "tr>td", :text => "Phylogeny".to_s, :count => 2
    assert_select "tr>td", :text => "Distn".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
