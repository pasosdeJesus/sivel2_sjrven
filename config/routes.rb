Rails.application.routes.draw do

  devise_scope :usuario do
    get 'sign_out' => 'devise/sessions#destroy'

    # El siguiente para superar mala generación del action en el formulario
    # cuando se autentica mal (genera 
    # /puntomontaje/puntomontaje/usuarios/sign_in )
    if (Rails.configuration.relative_url_root != '/') 
      ruta = File.join(Rails.configuration.relative_url_root, 
                       'usuarios/sign_in')
      post ruta, to: 'devise/sessions#create'
    end
  end
  devise_for :usuarios, :skip => [:registrations], module: :devise
    as :usuario do
          get 'usuarios/edit' => 'devise/registrations#edit', 
            :as => 'editar_registro_usuario'    
          put 'usuarios/:id' => 'devise/registrations#update', 
            :as => 'registro_usuario'            
  end
  resources :usuarios, path_names: { new: 'nuevo', edit: 'edita' } 

  patch "/actos/agregar" => 'sivel2_sjr/actos#agregar'
  get "/actos/eliminar" => 'sivel2_sjr/actos#eliminar'
  
  get "/personas" => 'sivel2_sjr/personas#index'
  get "/personas/remplazar" => 'sivel2_sjr/personas#remplazar'

  #root 'sivel2_gen/hogar#index'
  root "sip/hogar#index"
  mount Sivel2Sjr::Engine => "/", as: 'sivel2_sjr'
  mount Sivel2Gen::Engine => "/", as: 'sivel2_gen'
  mount Cor1440Gen::Engine => "/", as: 'cor1440_gen'
  mount Sal7711Gen::Engine => "/", as: 'sal7711_gen'
  mount Sal7711Web::Engine => "/", as: 'sal7711_web'
  mount Heb412Gen::Engine, at: "/", as: "heb412_gen"
  mount Sip::Engine => "/", as: 'sip'


  namespace :admin do
    ab = ::Ability.new
    ab.tablasbasicas.each do |t|
      if (t[0] == "") 
        c = t[1].pluralize
        resources c.to_sym, 
          path_names: { new: 'nueva', edit: 'edita' }
      end
    end
  end
end
