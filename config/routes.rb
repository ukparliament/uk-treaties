Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  get '/' => 'home#index', :as => 'home'
  
  get 'agreements' => 'agreement#index', :as => 'agreement_list'
  get 'agreements/:agreement' => 'agreement#show', :as => 'agreement_show'
  
  get 'subjects' => 'subject#index', :as => 'subject_list'
  get 'subjects/:subject' => 'subject#show', :as => 'subject_show'
  
  get 'parties' => 'party#index', :as => 'party_list'
  get 'parties/:party' => 'party#show', :as => 'party_show'
  
  get 'action-types' => 'action_type#index', :as => 'action_type_list'
  get 'action-types/:action_type' => 'action_type#show', :as => 'action_type_show'
end
