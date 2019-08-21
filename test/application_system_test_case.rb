require "test_helper"

class NilLogger
    def puts * ; end
end


# Usuario para ingresar y hacer pruebas
PRUEBA_USUARIO = {
  nusuario: "admin",
  password: "sjrven123",
  nombre: "admin",
  descripcion: "admin",
  rol: 1,
  idioma: "es_CO",
  email: "usuario1@localhost",
  encrypted_password: '$2a$10$uMAciEcJuUXDnpelfSH6He7BxW0yBeq6VMemlWc5xEl6NZRDYVA3G',
  sign_in_count: 0,
  fechacreacion: "2014-08-05",
  fechadeshabilitacion: nil,
  oficina_id: nil
}

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase

  driven_by :selenium, usign: :headless_chrome,
    screen_size: [1400, 1400], options: { 
    #js_errors: true,
    #logger: NilLogger.new#,
#    phantomjs_logger: STDOUT,
#    phantomjs_options: ['--debug=true'],
#    debug: true 
  }

  def setup
#    load "#{Rails.root}/db/seeds.rb"
  end

  def teardown
  end

end
