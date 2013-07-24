Olamundo::Application.routes.draw do
  #resources :user_category_related_symbols
  #
  #resources :user_category_symbols
  #
  #resources :user_categories

  resources :symbol_banks do
    collection do
      delete "delete_symbols_from_bank"
      get "rename_symbols"
      put "update_symbol_name"
      delete "cancel_symbols_saving"
    end
  end

  resources :messages

  resources :ipad_devises

  resources :relatedsymbols do
    collection do
      get "add_related_symbol"
    end
  end

  resources :catgorysymbols

  resources :members

  resources :apns

  devise_for :users
  resources :home do
    collection do
      post "bulk_upload"
    end
  end

  match "upload", :to => "home#bulk_upload", via: :get

  resources :members do
    collection do
      post "update_members"
    end
  end

  resources :categories do

    collection do
      get "add_bulk_symbol"
    end
  end

  resources :symbol1s do
    collection do
      get "sequence_order"
      post "update_sequence_order"
      get "autoload_word"
      get "search_symbol"
      get "symbol_image_show"
      post "save_images_files"
      get "update_symbol"
      delete "delete_symbol"
      delete "cancel_symbols_saving"
      delete "delete_bulk_symbols"
      post "upload_file_from_ipad"
    end
  end

  #root :to => 'home#home_page'
  root :to => 'home#index'

  get "test_value" => "categories#test_val"
  get "edit_family_member/:id", :to => "members#edit_family_member"
  get "add_member/:id", :to => "members#add_member"
  get "account_messages", :to => "messages#account_messages"
  get "send_log_mail", :to => "messages#send_log_mail"

  post "save_bulk_symbols", :to => "symbol1s#save_bulk_symbols"
  post "update_user_members", :to => "members#update_members"
  post "create_member", :to => "members#create_member"

  match "categories_symbols", :to => "categories#get_category_symbols", via: :get
  match "checkUnReadMessages", :to => "messages#checkUnReadMessages", via: :get
  match "get_all_category_symbols", :to => "categories#get_all_category_symbols", via: :get
  match "bulk_upload_symbols", :to => "symbol1s#bulk_symbol_upload", via: :get
  match "get_categories", :to => "categories#get_all_categories", via: :get
  match "get_category_symbols", :to => "symbol1s#get_all_symbols", via: :get
  match "get_updated_categories", :to => "categories#get_updated_categories", via: :get
  match "get_updated_symbols", :to => "symbol1s#get_updated_symbols", via: :get
  match "get_updated_related_symbols", :to => "relatedsymbols#get_updated_related_symbols", via: :get
  match "updated_categories_symbols", :to => "categories#get_updated_categories_symbols", via: :get
  match "same_image", :to => "relatedsymbols#same_image_name", via: :get
  match "requesting_messages", :to => "messages#requesting_messages", via: :get
  match "get_categories_colors", :to => "categories#get_categories_color", via: :get
  match "family_lists", :to => "home#family_list", via: :get

  delete "delete_family_member", :to => "members#delete_family_member"
  delete "delete_user", :to => "home#delete_user"

  devise_scope :user do
    get "sign_in", :to => "devise/sessions#new"
    get "sign_up", :to => "devise/registrations#new"
    get "sign_out", :to => "devise/sessions#destroy"
    match "verify_account", :to => "devise/registrations#verify_account", via: :get
    put "account_verification", :to => "devise/registrations#verify_account"
    match "resend_verification_code", :to => "devise/registrations#resend_verification_code", via: :get
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  # match 'member_delete' =>'members#destroy'
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
