Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    put 'users', :to => 'users#update'
    resource :session, only: [:create]
  end
end
