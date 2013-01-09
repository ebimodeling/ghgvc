require 'spec_helper'

describe "variables/show" do
  before(:each) do
    @variable = assign(:variable, stub_model(Variable,
      :description => "Description",
      :units => "Units",
      :notes => "MyText",
      :name => "Name",
      :max => "Max",
      :min => "Min"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    rendered.should match(/Units/)
    rendered.should match(/MyText/)
    rendered.should match(/Name/)
    rendered.should match(/Max/)
    rendered.should match(/Min/)
  end
end
