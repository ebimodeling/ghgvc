require 'spec_helper'

describe "citations/show" do
  before(:each) do
    @citation = assign(:citation, stub_model(Citation,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Author/)
    rendered.should match(/1/)
    rendered.should match(/Title/)
    rendered.should match(/Journal/)
    rendered.should match(/2/)
    rendered.should match(/Pg/)
    rendered.should match(/Url/)
    rendered.should match(/Pdf/)
    rendered.should match(/Doi/)
    rendered.should match(/3/)
  end
end
