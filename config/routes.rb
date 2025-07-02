Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root 'home#index'

  get 'uk-treaties/' => 'home#index', :as => 'home'
  
  get 'uk-treaties/treaties' => 'treaty#index', :as => 'treaty_list'
  get 'uk-treaties/treaties/:treaty' => 'treaty#show', :as => 'treaty_show'
  
  get 'uk-treaties/treaty-types' => 'treaty_type#index', :as => 'treaty_type_list'
  get 'uk-treaties/treaty-types/:treaty_type' => 'treaty_type#show', :as => 'treaty_type_show'
  
  get 'uk-treaties/subjects' => 'subject#index', :as => 'subject_list'
  get 'uk-treaties/subjects/:subject' => 'subject#show', :as => 'subject_show'
  
  get 'uk-treaties/parties' => 'party#index', :as => 'party_list'
  get 'uk-treaties/parties/:party' => 'party#show', :as => 'party_show'
  get 'uk-treaties/parties/:party/actions' => 'party#action_list', :as => 'party_action_list'
  get 'uk-treaties/parties/:party/treaties' => 'party#treaty_list', :as => 'party_treaty_list'
  
  get 'uk-treaties/action-types' => 'action_type#index', :as => 'action_type_list'
  get 'uk-treaties/action-types/:action_type' => 'action_type#show', :as => 'action_type_show'
  
  get 'uk-treaties/locations' => 'location#index', :as => 'location_list'
  get 'uk-treaties/locations/:location' => 'location#show', :as => 'location_show'
  
  get 'uk-treaties/colophon' => 'colophon#index', :as => 'colophon_list'
  get 'uk-treaties/privacy-policy' => 'privacy#index', :as => 'privacy_list'
  
  get 'uk-treaties/meta' => 'meta#index', :as => 'meta_list'
  get 'uk-treaties/meta/cookies' => 'meta#cookies', :as => 'meta_cookies'
end
