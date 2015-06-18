Norma::Application.routes.draw do
  match '/index', :to => 'pages#index'
  match '/about_us', :to => 'pages#about_us'
  match '/comments', :to => 'comments#index'
  match '/contacts', :to => 'pages#contacts'
  
  
  resources :comments


  get "sessions/new"

  get "sessions/create"

  get "sessions/destroy"

  resources :sessions, :only => [:new, :create, :destroy]

  get "admin_tools/admin_entry"

  get "admin_tools/user_update"

  get "admin_tools/site_entry"

  get "admin_tools/sign_up"
  
  get "admin_tools/create_user"

  post "messages/new"
  
  resources :attachment_files


  resources :attachments


  resources :photos


  resources :products

  resources :messages
	
  get "pages/index"
 
  match '/site_entry',  :to => 'sessions#new'
  match '/user_update',  :to => 'admin_tools#user_update'
  match '/sign_up',  :to => 'admin_tools#sign_up'
  match '/create_user',  :to => 'admin_tools#create_user' #Новый пользователь
  match '/sign_out',  :to => 'sessions#destroy'
  match '/destroy_file/:id', :to => 'attachment_files#destroy'
  match '/send_mail',  :to => 'messages#create'
  match '/save_as_draft',  :to => 'messages#save_as_draft'
  match '/send_mails', :to => 'messages#send_mails'
  match '/change_folder', :to => 'messages#change_folder'
  match '/return_to_folder', :to => 'messages#return_to_folder'
  match '/clean_folder', :to => 'messages#clean_folder'
  match '/reply_to', :to => 'messages#new_reply'
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'pages#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
