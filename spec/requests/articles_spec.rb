require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  describe 'GET v1/articles' do
    it 'works! (now write some real specs)' do
      get v1_articles_path
      expect(response).to have_http_status(200)
    end
  end
end
