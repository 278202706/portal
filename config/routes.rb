Cloudweb::Application.routes.draw do
  get "adaccount/dashboard"
  get "adservice/dashboard"
  get "adapplications/dashboard"
  get "adresource/dashboard"
  get "service/market"
  get "service/applylist"
  get "service/manage"
  get "applications/dashboard"
  get "applications/manage"
  get "applications/service"
  get "resource/dashboard"
  get "resource/software"
  get "resource/virtualmac"
  get "resource/network"
  get "home/index"
  get "login/log"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get 'resource/crebusact'=> 'resource#crebusact'
  get 'service/apmysql'=> 'service#apmysql'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'resource/softintro/:id' => 'resource#softintro'
  get 'resource/softnow/:id' => 'resource#softnow'
  get 'resource/business/:id' => 'resource#business'
  get 'resource/unitcontainer/:id' => 'resource#unitcontainer'
  get "resource/deletecontainer/:id" => 'resource#deletecontainer'

  get 'resource/unitvirmac/:id' => 'resource#unitvirmac'
  get 'applications/unitapp/:id' => 'applications#unitapp'
 namespace :iaas do
    array = [:cmp_droplet, :cmp_loadbalance,:cmp_owner, :cmp_vguest,:test,
             :cmp_ownercontainer,:cmp_public_ip,:cmp_storagevolume]
    array.each do |con|
      get "#{con.to_s}", to: "#{con.to_s}#index"  
      match "#{con.to_s}(/:action(/:id))" ,to: "#{con.to_s}#action" ,via: :all
    end
  end

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

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
  #get ':controller/:action/:id'
 # match ':controller/:action/:id', to: ':controller#:action', via: :all
  #get ':controller(/:action(/:id))'
  match ':controller(/:action(/:id))',via: :all

end
