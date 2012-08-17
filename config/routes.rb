Carterapp::Application.routes.draw do
  #match "/:id", :controller => "dashboards", :action =>"show"
  devise_for :users

  resources :users
  resources :dashboards

  # devise_scope :user do
  #     get "/login" => "devise/sessions#new"
  #     delete "/logout" => "devise/sessions#destroy"
  #   end
  root :to => "dashboards#show"

end
