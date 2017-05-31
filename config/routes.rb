Rails.application.routes.draw do
  scope module: 'api' do
    namespace :v1 do
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
      get 'versions/:id/:type', to: 'versions#text'
      get 'versions/:id/diff/:another_id', to: 'versions#diff'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
