Rails.application.routes.draw do
  root 'locales#index'
  post '/locales/commit', controller: 'locales', action: 'commit'
  resources :locales

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
