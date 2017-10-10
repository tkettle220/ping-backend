Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    post 'location', :to => 'users#update'
    post 'request_friend', :to => 'users#request_friend'
    post 'ping_friend', :to => 'users#ping'
    post 'get_pings', :to => 'users#get_pings'
    resource :session, only: [:create]
  end
end
