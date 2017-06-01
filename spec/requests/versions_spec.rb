require 'rails_helper'

RSpec.describe "Versions", type: :request do
  describe "GET v1/versions" do
    it "works! (now write some real specs)" do
      get v1_versions_path
      expect(response).to have_http_status(200)
    end
  end
end
