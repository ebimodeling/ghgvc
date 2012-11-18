require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do
    it "should have the content 'GCS is a consulting company'" do
      visit '/home'
      page.should have_content('GCS is a consulting company')
    end
  end

  describe "Contact page" do
    it "should have the content '605 West Delaware Avenue'" do
      visit '/contact'
      page.should have_content('605 West Delaware Avenue')
    end
  end

  describe "Team page" do
    before { visit '/team' }
    it "should have the content 'Evan Delucia'" do
      page.should have_content('Evan Delucia')
    end
    it "should have the content 'Stephen Long'" do
      page.should have_content('Stephen Long')
    end
    it "should have the content 'Benjamin Duval'" do
      page.should have_content('Benjamin Duval')
    end
    it "should have the content 'Kristina Anderson-Teixeira'" do
      page.should have_content('Kristina Anderson-Teixeira')
    end    
  end

  describe "Clients page" do
    it "should have the content 'BP is one of the world'" do
      visit '/clients'
      page.should have_content('BP is one of the world')
    end
  end

  describe "Services page" do
    subject { page }
    before { visit '/services' }
    it { should have_selector('h2', text: 'Crop production') }
    it { should have_selector('h2', text: 'TreeHuggers') }
  end

  describe "Research page" do
    subject { page }
    before { visit '/research' }
    it { should have_selector('h2', text: 'Media Coverage') }
    it { should have_selector('h2', text: 'Publications') }
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






