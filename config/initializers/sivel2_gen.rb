require 'sivel2_gen/version'

Sivel2Gen.setup do |config|
      config.ruta_anexos = "/var/www/resbase/anexos-sjrven"
      config.ruta_volcados = "/var/www/resbase/sivel2_sjrven/"
      # En heroku los anexos son super-temporales
      if !ENV["HEROKU_POSTGRESQL_GREEN_URL"].nil?
        config.ruta_anexos = "#{Rails.root}/tmp/"
      end
      config.titulo = "SIVeL - SJR Venezuela " + Sivel2Gen::VERSION
end
