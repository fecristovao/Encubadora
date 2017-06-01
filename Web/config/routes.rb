Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/list', to: 'controlador#list'
  get '/:year/:month/:day', to: 'controlador#day'
  root 'controlador#index'
end
