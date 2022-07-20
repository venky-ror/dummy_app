Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api/v1', defaults: {format: :json} do
    devise_for :users, controllers: {sessions: 'api/v1/sessions', registrations: 'api/v1/registrations'}
  end
  namespace :api do
    namespace :v1 do
       resources :articles do
       end
    end
  end
end
