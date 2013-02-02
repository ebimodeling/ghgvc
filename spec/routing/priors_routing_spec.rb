require "spec_helper"

describe PriorsController do
  describe "routing" do

    it "routes to #index" do
      get("/priors").should route_to("priors#index")
    end

    it "routes to #new" do
      get("/priors/new").should route_to("priors#new")
    end

    it "routes to #show" do
      get("/priors/1").should route_to("priors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/priors/1/edit").should route_to("priors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/priors").should route_to("priors#create")
    end

    it "routes to #update" do
      put("/priors/1").should route_to("priors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/priors/1").should route_to("priors#destroy", :id => "1")
    end

  end
end
