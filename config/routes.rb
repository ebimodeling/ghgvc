Rails.application.routes.draw do
  resources :variables
  resources :citations
  resources :priors
  resources :workflows
  resources :pfts
  resources :users

  get 'calculator' => 'workflows#new'

  # Static pages
  get 'about' => 'static_pages#about'

  # AJAX handlers
  get 'get_biome' => 'workflows#get_biome'
  post 'create_config_input' => 'workflows#create_config_input'
  get 'download_csv' => 'workflows#download_csv'

  root :to => 'workflows#new'
end
