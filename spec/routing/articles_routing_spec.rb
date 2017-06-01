require "rails_helper"

RSpec.describe Api::V1::ArticlesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/v1/articles").to route_to("api/v1/articles#index")
    end

    it "routes to #show" do
      expect(:get => "/v1/articles/1").to route_to("api/v1/articles#show", :id => "1")
    end

  end
end
