require 'rails_helper'

RSpec.describe Api::V1::VersionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/versions').to route_to('api/v1/versions#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/versions/1').to route_to('api/v1/versions#show', id: '1')
    end
  end
end
