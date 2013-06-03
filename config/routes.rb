Kochkultur::Application.routes.draw do
  root :to => 'places#index'

  match '/activate/:activation_code' => 'users#activate', :as => :activate
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/places/tag/:tag' => 'places#index'
  match '/places/all' => 'places#index', :page => 'all'
  match '/places/:page' => 'places#index', :page => /\d{1}/
  resources :users
  resource :session
  resources :contacts
  resources :posts
  resources :places do
    put :rate
  end
  
  resources :pictures
  resources :comments
  resources :tags
  match '/kontakt' => 'contacts#new', :as => :new_contact
  match '/anzeigen' => 'posts#index', :as => :nice_posts
  match '/anzeige' => 'posts#new', :as => :nice_new_post
  match '/:controller(/:action(/:id))'
end
