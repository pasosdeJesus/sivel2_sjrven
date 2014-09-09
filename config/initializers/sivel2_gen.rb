Sivel2Gen.setup do |config|
      config.ruta_anexos = "/var/www/resbase/anexos-sjrven"
      # En heroku los anexos son super-temporales
      if !ENV["HEROKU_POSTGRESQL_GREEN_URL"].nil?
        config.ruta_anexos = "#{Rails.root}/tmp/"
      end
      config.titulo = "SIVeL " + Sivel2Gen::VERSION
end
