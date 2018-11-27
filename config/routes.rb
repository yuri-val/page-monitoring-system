Rails.application.routes.draw do
  root to: 'routes#index'
  scope module: 'api' do
    namespace :v1 do
      get 'articles/changed', to: 'articles#changed'
      get 'versions/:id/:type', to: 'versions#text'
      get 'versions/:id/diff/:another_id', to: 'versions#diff'

      resources :sites, only: %i[index show] do
        resources :articles, only: %i[index show]
      end
      resources :articles, only: %i[index show] do
        resources :versions, only: %i[index show]
      end
      resources :versions, only: %i[index show]
      resources :statuses, only: %i[index show] do
        resources :articles, only: %i[index show]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
