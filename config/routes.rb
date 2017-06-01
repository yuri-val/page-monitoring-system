Rails.application.routes.draw do
  root to: 'routes#index'
  scope module: 'api' do
    namespace :v1 do
      get 'articles/changed', to: 'articles#changed'
      get 'versions/:id/:type', to: 'versions#text'
      get 'versions/:id/diff/:another_id', to: 'versions#diff'

      resources :sites, only: [:index, :show] do
        resources :articles, only: [:index, :show]
      end
      resources :articles, only: [:index, :show] do
        resources :versions, only: [:index, :show]
      end
      resources :versions, only: [:index, :show]
      resources :statuses, only: [:index, :show] do
        resources :articles, only: [:index, :show]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
