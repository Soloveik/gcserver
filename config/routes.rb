Rails.application.routes.draw do
  get 'main/index'
  match '/testclose', :to => "main#testclose", :as => :testclose, via: [:get, :post]
  match '/start_socket', :to => "main#start_socket", :as => :start_socket, via: [:get, :post]
  match '/close_socket', :to => "main#close_socket", :as => :close_socket, via: [:get, :post]
  match '/set_inf/:key/:value', :to => "main#set_inf", :as => :set_inf, via: [:get, :post]
  match '/get_inf/:key', :to => "main#get_inf", :as => :get_inf, via: [:get, :post]
  # match '/del_inf_by_val/:key/:value', :to => "main#del_inf_by_val", :as => :del_inf_by_val, via: [:get, :post]
  match '/del_inf_by_key/:key', :to => "main#del_inf_by_key", :as => :del_inf_by_key, via: [:get, :post]
  match '/del_inf_all', :to => "main#del_inf_all", :as => :del_inf_all, via: [:get, :post]
  match '/api/wry', to: "api#wry", as: :wry, via: [:get, :post]
  match '/api/wryg', to: "api#wry_group", as: :wry_group, via: [:get, :post]
  match '/api/imh', to: "api#im_here", as: :im_here, via: [:get, :post]
  match '/api/imhg', to: "api#im_here_group", as: :im_here_group, via: [:get, :post]
  match '/api/gmd', to: "api#get_my_data", as: :get_my_data, via: [:get, :post]
  match '/api/im', to: "api#im", as: :im, via: [:get, :post]
  match '/api/ng', to: "api#new_group", as: :new_group, via: [:get, :post]
  match '/api/addutg', to: "api#add_user_to_group", as: :add_user_to_group, via: [:get, :post]
  match '/api/delufg', to: "api#del_user_from_group", as: :del_user_from_group, via: [:get, :post]
  match '/test', to: "api#test", as: :test, via: [:get, :post]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
