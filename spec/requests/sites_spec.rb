require 'rails_helper'

RSpec.describe "Sites", type: :request do
  describe "GET v1/sites" do
    it "works! (now write some real specs)" do
      get v1_sites_path
      expect(response).to have_http_status(200)
    end
  end
end
