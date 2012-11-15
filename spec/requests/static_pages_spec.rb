require 'spec_helper'

describe "Home page" do

  it "should have the content 'GCS is a consulting company'" do
    visit '/static_pages/home'
    page.should have_content('GCS is a consulting company')
  end
end


