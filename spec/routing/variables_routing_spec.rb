require "spec_helper"

describe VariablesController do
  describe "routing" do

    it "routes to #index" do
      get("/variables").should route_to("variables#index")
    end

    it "routes to #new" do
      get("/variables/new").should route_to("variables#new")
    end

    it "routes to #show" do
      get("/variables/1").should route_to("variables#show", :id => "1")
    end

    it "routes to #edit" do
      get("/variables/1/edit").should route_to("variables#edit", :id => "1")
    end

    it "routes to #create" do
      post("/variables").should route_to("variables#create")
    end

    it "routes to #update" do
      put("/variables/1").should route_to("variables#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/variables/1").should route_to("variables#destroy", :id => "1")
    end

  end
end
