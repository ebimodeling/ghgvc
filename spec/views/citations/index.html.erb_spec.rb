require 'spec_helper'

describe "citations/index" do
  before(:each) do
    assign(:citations, [
      stub_model(Citation,
        :author => "Author",
        :year => 1,
        :title => "Title",
        :journal => "Journal",
        :vol => 2,
        :pg => "Pg",
        :url => "Url",
        :pdf => "Pdf",
        :doi => "Doi",
        :user_id => 3
      ),
      stub_model(Citation,
        :author => "Author",
        :year => 1,
        :title => "Title",
        :journal => "Journal",
        :vol => 2,
        :pg => "Pg",
        :url => "Url",
        :pdf => "Pdf",
        :doi => "Doi",
        :user_id => 3
      )
    ])
  end

  it "renders a list of citations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Author".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Journal".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Pg".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Pdf".to_s, :count => 2
    assert_select "tr>td", :text => "Doi".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
