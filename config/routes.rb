Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  get '/' => 'home#index', :as => 'home'
  
  get 'treaties' => 'treaty#index', :as => 'treaty_list'
  get 'treaties/:treaty' => 'treaty#show', :as => 'treaty_show'
  
  get 'treaty-types' => 'treaty_type#index', :as => 'treaty_type_list'
  get 'treaty-types/:treaty_type' => 'treaty_type#show', :as => 'treaty_type_show'
  
  get 'subjects' => 'subject#index', :as => 'subject_list'
  get 'subjects/:subject' => 'subject#show', :as => 'subject_show'
  
  
  
  
  
  
  
  
  
  
  get 'parties' => 'party#index', :as => 'party_list'
  get 'parties/:party' => 'party#show', :as => 'party_show'
  
  get 'action-types' => 'action_type#index', :as => 'action_type_list'
  get 'action-types/:action_type' => 'action_type#show', :as => 'action_type_show'
end
