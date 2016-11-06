Rails.application.routes.draw do
  get 'main/index'
  match '/test', :to => "main#test", :as => :test, via: [:get, :post]
  match '/testclose', :to => "main#testclose", :as => :testclose, via: [:get, :post]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
