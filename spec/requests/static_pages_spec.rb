require 'spec_helper'

describe "Home page" do

  it "should have the content 'GCS is a consulting company'" do
    visit '/static_pages/home'
    page.should have_content('GCS is a consulting company')
  end
end

#describe "Home page" do
#  before { visit root_path } 

#  it "should have the h1 'Sample App'" do
#    page.should have_selector('h1', text: 'Sample App')
#  end

#  it "should have the base title" do
#    page.should have_selector('title',
#                      text: "Ruby on Rails Tutorial Sample App")
#  end

#  it "should not have a custom page title" do
#    page.should_not have_selector('title', text: '| Home')
#  end
#end
