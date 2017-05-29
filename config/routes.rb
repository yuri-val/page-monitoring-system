Rails.application.routes.draw do
  scope module: 'api' do
    namespace :v1 do
      resources :versions, only: [:index, :show]
      resources :statuses, only: [:index, :show]
      resources :articles, only: [:index, :show]
      resources :sites, only: [:index, :show]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
