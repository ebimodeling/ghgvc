require 'spec_helper'

describe "citations/edit" do
  before(:each) do
    @citation = assign(:citation, stub_model(Citation,
      :author => "MyString",
      :year => 1,
      :title => "MyString",
      :journal => "MyString",
      :vol => 1,
      :pg => "MyString",
      :url => "MyString",
      :pdf => "MyString",
      :doi => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit citation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => citations_path(@citation), :method => "post" do
      assert_select "input#citation_author", :name => "citation[author]"
      assert_select "input#citation_year", :name => "citation[year]"
      assert_select "input#citation_title", :name => "citation[title]"
      assert_select "input#citation_journal", :name => "citation[journal]"
      assert_select "input#citation_vol", :name => "citation[vol]"
      assert_select "input#citation_pg", :name => "citation[pg]"
      assert_select "input#citation_url", :name => "citation[url]"
      assert_select "input#citation_pdf", :name => "citation[pdf]"
      assert_select "input#citation_doi", :name => "citation[doi]"
      assert_select "input#citation_user_id", :name => "citation[user_id]"
    end
  end
end
