require 'spec_helper'

describe "priors/edit" do
  before(:each) do
    @prior = assign(:prior, stub_model(Prior,
      :citation_id => 1,
      :variable_id => "MyString",
      :phylogeny => "MyString",
      :distn => "MyString",
      :parama => "9.99",
      :paramb => "9.99",
      :paramc => "9.99",
      :n => 1,
      :notes => "MyText"
    ))
  end

  it "renders the edit prior form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => priors_path(@prior), :method => "post" do
      assert_select "input#prior_citation_id", :name => "prior[citation_id]"
      assert_select "input#prior_variable_id", :name => "prior[variable_id]"
      assert_select "input#prior_phylogeny", :name => "prior[phylogeny]"
      assert_select "input#prior_distn", :name => "prior[distn]"
      assert_select "input#prior_parama", :name => "prior[parama]"
      assert_select "input#prior_paramb", :name => "prior[paramb]"
      assert_select "input#prior_paramc", :name => "prior[paramc]"
      assert_select "input#prior_n", :name => "prior[n]"
      assert_select "textarea#prior_notes", :name => "prior[notes]"
    end
  end
end
