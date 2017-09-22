Rails.application.routes.draw do
  resources :breeds do
    member do
      get 'tags' => 'breeds#get_tags'
      post 'tags' => 'breeds#post_tags'
    end
  end

  resources :tags, except: [:create]
end
