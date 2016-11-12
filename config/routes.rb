Rails.application.routes.draw do
  get 'main/index'
  match '/test', :to => "main#test", :as => :test, via: [:get, :post]
  match '/testclose', :to => "main#testclose", :as => :testclose, via: [:get, :post]
  match '/start_socket', :to => "main#start_socket", :as => :start_socket, via: [:get, :post]
  match '/close_socket', :to => "main#close_socket", :as => :close_socket, via: [:get, :post]
  match '/set_inf/:key/:value', :to => "main#set_inf", :as => :set_inf, via: [:get, :post]
  match '/get_inf/:key', :to => "main#get_inf", :as => :get_inf, via: [:get, :post]
  # match '/del_inf_by_val/:key/:value', :to => "main#del_inf_by_val", :as => :del_inf_by_val, via: [:get, :post]
  match '/del_inf_by_key/:key', :to => "main#del_inf_by_key", :as => :del_inf_by_key, via: [:get, :post]
  match '/del_inf_all', :to => "main#del_inf_all", :as => :del_inf_all, via: [:get, :post]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
