source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" } 

ruby '>= 2.6.0'

gem 'bcrypt'

gem 'bootsnap', '>=1.1.0', require: false

gem 'cancancan'

gem 'chartkick'

gem 'cocoon', git: 'https://github.com/vtamara/cocoon.git', branch: 'new_id_with_ajax' # Formularios anidados (algunos con ajax)

gem 'coffee-rails' # CoffeeScript para recuersos .js.coffee y vistas

gem 'devise' # Autenticación 

gem 'devise-i18n'

gem 'jbuilder' # API JSON facil. 

gem 'libxml-ruby'

gem 'odf-report' # Genera ODT

gem 'paperclip' # Maneja adjuntos

gem 'pg' # Postgresql

gem 'prawn' # Generación de PDF

gem 'prawnto_2',  :require => 'prawnto'

gem 'prawn-table'

gem 'puma'# Servidor web

gem 'rails', '~> 6.0.0.rc1' # Rails 

gem 'rails-i18n'

gem 'redcarpet'

gem 'rspreadsheet'

gem 'rubyzip', '>=2.0.0'

gem 'sassc-rails'

gem 'simple_form' # Formularios simples 

gem 'twitter_cldr' # ICU con CLDR

gem 'tzinfo' # Zonas horarias

gem 'webpacker'

gem 'will_paginate'
 

#####
# Motores que se sobrecargan vistas (deben ponerse en orden de apilamiento 
# lógico y no alfabetico como las gemas anteriores) 

gem 'sip', # Motor generico
  git: 'https://github.com/pasosdeJesus/sip.git'
  #path: '../sip'

gem 'mr519_gen', # Motor de gestion de formularios y encuestas
  git: 'https://github.com/pasosdeJesus/mr519_gen.git'
  #path: '../mr519_gen'

gem 'heb412_gen',  # Motor de nube y llenado de plantillas
  git: 'https://github.com/pasosdeJesus/heb412_gen.git'
  #path: '../heb412_gen'

gem 'cor1440_gen', # Motor de actividades y proyectos financiaods con ML
  git: 'https://github.com/pasosdeJesus/cor1440_gen.git'
  #path: '../cor1440_gen'

gem 'sal7711_gen', # Motor Archivo de prensa
  git: 'https://github.com/pasosdeJesus/sal7711_gen.git'
  #path: '../sal7711_gen'

gem 'sal7711_web', # Motor Archivo de prensa web
  git: 'https://github.com/pasosdeJesus/sal7711_web.git'
  #path: '../sal7711_web'

gem 'sivel2_gen', # Motor Casos
  git: 'https://github.com/pasosdeJesus/sivel2_gen.git'
  #path: '../sivel2_gen'

gem 'sivel2_sjr', # Motor Atención a casos
  git: 'https://github.com/pasosdeJesus/sivel2_sjr.git'
  #path: '../sivel2_sjr'


group :development do
  
  gem 'web-console' # Consola irb en páginas 

  gem 'colorize' # Colores en terminal

end


group :development, :test do
  
  #gem 'byebug' # Depurar
  
end


group :test do

  gem 'capybara'

  gem 'chromedriver-helper'

  gem 'minitest'

  gem 'selenium-webdriver'

  gem 'simplecov'

  gem 'spring'

end


group :production do
  
  gem 'unicorn' # Para despliegue

end
