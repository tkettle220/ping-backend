Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'

  namespace :api, defaults: { format: :json } do
    post 'location', :to => 'users#update'
    post 'friends', :to => 'users#friends'
    post 'request_friend', :to => 'users#request_friend'
    post 'approve_friend', :to => 'users#approve_friend'
    post 'delete_friend', :to => 'users#delete_friend'
    post 'ping_friend', :to => 'users#ping'
    post 'get_pings', :to => 'users#get_pings'
    post 'push_token', :to => 'tokens#create'
    post 'send_push', :to => 'tokens#send_push'
    post 'update_settings', :to => 'users#update_settings'
    post 'get_own_location', :to => 'users#get_own_location'
    resource :session, only: [:create]
    resources :messages, only: [:create, :show]
  end
end
