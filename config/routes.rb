Rails.application.routes.draw do
  get 'main/index'
  match '/test', :to => "main#test", :as => :test, via: [:get, :post]
  match '/testclose', :to => "main#testclose", :as => :testclose, via: [:get, :post]
  match '/start_socket', :to => "main#start_socket", :as => :start_socket, via: [:get, :post]
  match '/close_socket', :to => "main#close_socket", :as => :close_socket, via: [:get, :post]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
