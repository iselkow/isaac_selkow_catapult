Rails.application.routes.draw do
  resources :breeds do
    member do
      get 'tags' => 'breeds#get_tags'
      post 'tags' => 'breeds#post_tags'
    end

    get 'stats', on: :collection
  end

  resources :tags, except: [:create] do
    get 'stats', on: :collection
  end
end
