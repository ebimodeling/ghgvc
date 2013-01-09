require 'spec_helper'

describe "variables/index" do
  before(:each) do
    assign(:variables, [
      stub_model(Variable,
        :description => "Description",
        :units => "Units",
        :notes => "MyText",
        :name => "Name",
        :max => "Max",
        :min => "Min"
      ),
      stub_model(Variable,
        :description => "Description",
        :units => "Units",
        :notes => "MyText",
        :name => "Name",
        :max => "Max",
        :min => "Min"
      )
    ])
  end

  it "renders a list of variables" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Units".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Max".to_s, :count => 2
    assert_select "tr>td", :text => "Min".to_s, :count => 2
  end
end
