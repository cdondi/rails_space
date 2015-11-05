Rails.application.routes.draw do
  get 'email/remind'
  get 'email/correspond'
  get 'avatar/index'
  get 'avatar/upload'
  get 'avatar/delete'
  get 'community/index'
  get 'community/browse'
  get 'community/search'
  get 'faq/index'
  get 'faq/edit'
  get 'spec/index'
  get 'spec/edit'

  #get 'profile/:screen_name', :controller => 'profile', :action => 'show'

  # Install the default routes as the lowest priority.
  #map.connect ':controller/:action/:id'

  get 'profile/index'
  get 'user/index', as: :hub
  get 'user/register'
  get 'user/login'
  get 'user/logout'
  get 'site/about'
  get 'site/help'
  get 'site/index'
  get 'user/edit'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'site#index'

  post 'user/index'
  post 'user/register'
  post 'user/login'
  post 'user/logout'
  post 'site/help'
  post 'user/index'
  post 'user/edit'
  post 'spec/edit'
  post 'faq/edit'
  post 'avatar/upload'
  post 'email/remind'
  post 'email/correspond'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  #post 'correspond/:id' => 'profile#show'
  #get 'correspond/:id' => 'profile#show'
  get 'friendship/:id/create' => 'friendship#create'
  get 'profile/:screen_name' => 'profile#show', as: :profile
  get 'community/index/:id' => "community#index"
  get 'community/' => "community#index"

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
     resources :user do
       member do
         post 'correspond'
         get 'correspond'
       end
  #
  #     collection do
  #       get 'sold'
  #     end
     end

  resources :friendship do
    member do
      post 'create'
      post 'accept'
      get 'accept'
      post 'decline'
      get 'decline'
      post 'delete'
      post 'cancel'
      get 'cancel'
    end
  end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
