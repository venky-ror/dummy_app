Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
       devise_for :users, controllers: {sessions: 'api/v1/sessions', registrations: 'api/v1/registrations'}
       resources :articles do
       end
    end
  end
end
