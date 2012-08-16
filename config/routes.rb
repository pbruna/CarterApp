Carterapp::Application.routes.draw do
  devise_for :users

  resources :users
  resources :dashboards

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    delete "/logout" => "devise/sessions#destroy"
  end

  root :to => "dashboards", :action => "show"

end
