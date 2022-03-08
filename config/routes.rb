Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  get 'agreements' => 'agreement#index', :as => 'agreement_list'
  
  get 'subjects' => 'subject#index', :as => 'subject_list'
  get 'subjects/:subject' => 'subject#show', :as => 'subject_show'
end
