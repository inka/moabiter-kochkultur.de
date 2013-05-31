ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
#  map.signup '/signup', :controller => 'sessions', :action => 'signup'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.connect '/places/tag/:tag',  :controller => "places", :action => 'index'
  map.connect '/places/all',  :controller => "places", :action => 'index', :page => 'all'
  map.connect '/places/:page',  :controller => "places", :action => 'index', :page => /\d{1}/

  map.resources :users
  map.resource  :session
  map.resources :contacts
  map.resources :posts
  map.resources :places, :has_many => :comments#, :shallow => true
  map.resources :places, :member => { :rate => :put }
  map.resources :pictures
  map.resources :comments
  map.resources :tags

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "places", :action => 'index'

  # named routes
  #map.projekt       '/projekt',  :controller => "home", :action => 'projekt'
  #map.karte         '/karte',    :controller => "home", :action => 'karte'
  #map.kultur        '/kultur',   :controller => "home", :action => 'karte'
  map.new_contact   '/kontakt',  :controller => "contacts", :action => 'new'
  map.nice_posts    '/anzeigen', :controller => "posts", :action => 'index'
  map.nice_new_post '/anzeige',  :controller => "posts", :action => 'new'

  #map.connect '/:action',  :controller => "home"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
