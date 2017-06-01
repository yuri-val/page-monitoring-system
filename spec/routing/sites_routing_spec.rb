require "rails_helper"

RSpec.describe Api::V1::SitesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/v1/sites").to route_to("api/v1/sites#index")
    end

    it "routes to #show" do
      expect(:get => "/v1/sites/1").to route_to("api/v1/sites#show", :id => "1")
    end

  end
end
