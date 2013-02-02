require 'spec_helper'

describe "variables/edit" do
  before(:each) do
    @variable = assign(:variable, stub_model(Variable,
      :description => "MyString",
      :units => "MyString",
      :notes => "MyText",
      :name => "MyString",
      :max => "MyString",
      :min => "MyString"
    ))
  end

  it "renders the edit variable form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => variables_path(@variable), :method => "post" do
      assert_select "input#variable_description", :name => "variable[description]"
      assert_select "input#variable_units", :name => "variable[units]"
      assert_select "textarea#variable_notes", :name => "variable[notes]"
      assert_select "input#variable_name", :name => "variable[name]"
      assert_select "input#variable_max", :name => "variable[max]"
      assert_select "input#variable_min", :name => "variable[min]"
    end
  end
end
