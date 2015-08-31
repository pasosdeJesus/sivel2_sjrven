source 'https://rubygems.org'

#ruby "2.1.5"

# Rails (internacionalización)
gem "rails", '~> 4.2.0'
gem "rails-i18n"

# Postgresql
gem "pg"

# Maneja variables de ambiente (como claves y secretos) en .env
gem "foreman"

# API JSON facil. Ver: https://github.com/rails/jbuilder
gem "jbuilder"

# SCSS para hojas de estilo
gem "sass"
gem "sass-rails"

# Colores en terminal
gem "colorize"

# Uglifier comprime recursos Javascript
gem "uglifier", '>= 1.3.0'

# CoffeeScript para recuersos .js.coffee y vistas
gem "coffee-rails", '~> 4.1.0'

# jquery como librería JavaScript
gem "jquery-rails"
gem "jquery-ui-rails"
gem "jquery-ui-bootstrap-rails", git: "https://github.com/kristianmandrup/jquery-ui-bootstrap-rails"

# Seguir enlaces más rápido. Ver: https://github.com/rails/turbolinks
gem "turbolinks"

# Ambiente de CSS
gem "twitter-bootstrap-rails"
gem "bootstrap-datepicker-rails"
gem "bootstrap-sass"

gem "chartkick"

# Formularios simples 
#gem "simple_form", git: "https://github.com/plataformatec/simple_form"
gem "simple_form"

# Formularios anidados (algunos con ajax)
gem "cocoon", github: "vtamara/cocoon"

# Autenticación y roles
gem "devise"
gem "devise-i18n"
gem "cancancan"
gem "bcrypt"

# Listados en páginas
gem "will_paginate"

# ICU con CLDR
gem 'twitter_cldr'

# Maneja adjuntos
gem "paperclip", "~> 4.1"

# Zonas horarias
gem "tzinfo"
gem "tzinfo-data"

# Motor SIP
gem 'sip', github: 'pasosdeJesus/sip'
#gem 'sip', path: '../sip'

# Motor de SIVeL 2
gem 'sivel2_gen', github: 'pasosdeJesus/sivel2_gen'
#gem 'sivel2_gen', path: '../sivel2_gen'

# Motor de SIVeL 2 - SJR
gem 'sivel2_sjr', github: 'pasosdeJesus/sivel2_sjr'
#gem 'sivel2_sjr', path: '../sivel2_sjr'

# Motor Cor1440_gen
gem 'cor1440_gen', github: 'pasosdeJesus/cor1440_gen'
#gem "cor1440_gen", path: '../cor1440_gen'


group :doc do
    # Genera documentación en doc/api con bundle exec rake doc:rails
    gem "sdoc", require: false
end

# Los siguientes son para desarrollo o para pruebas con generadores
group :development, :test do
  # Acelera desarrollo ejecutando en fondo.  https://github.com/jonleighton/spring
  gem "spring"

  # Pruebas con rspec
  gem 'spring-commands-rspec'
  gem 'rspec-rails'

  # Un proceso para cada prueba -- acelera
  gem 'spork', '~> 1.0rc'

  # Maneja datos de prueba
  gem "factory_girl_rails", "~> 4.0", group: [:development, :test]

  # https://www.relishapp.com/womply/rails-style-guide/docs/developing-rails-applications/bundler
  # Lanza programas para examinar resultados
  #gem "launchy"

  # Depurar
  #gem "byebug"
  
  # Consola irb en páginas con excepciones o usando <%= console %> en vistasA
  gem 'web-console'

  # Para examinar errores, usar "rescue rspec" en lugar de "rspec"
  gem 'pry-rescue'
  gem 'pry-stack_explorer'


end

# Los siguientes son para pruebas y no tiene generadores requeridos en desarrollo
group :test do
  # Pruebas de regresión que no requieren javascript
  gem "capybara"
  
  # Pruebas de regresión que requieren javascript
  gem "capybara-webkit"

  # Envia resultados de pruebas desde travis a codeclimate
  gem "codeclimate-test-reporter", require: nil
end

group :production do
  # Para despliegue
  gem "unicorn"

  # Requerido por heroku para usar stdout como bitacora
  gem "rails_12factor"
end

group :staging do
    gem "newrelic_rpm"
end
