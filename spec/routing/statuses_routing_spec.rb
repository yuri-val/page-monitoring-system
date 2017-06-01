require "rails_helper"

RSpec.describe Api::V1::StatusesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/v1/statuses").to route_to("api/v1/statuses#index")
    end

    it "routes to #show" do
      expect(:get => "/v1/statuses/1").to route_to("api/v1/statuses#show", :id => "1")
    end

  end
end
