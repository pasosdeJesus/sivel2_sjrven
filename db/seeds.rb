# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

conexion = ActiveRecord::Base.connection();


# De motores y finalmente este
motor = ['sip', 'sivel2_gen', 'sivel2_sjr', 'cor1440_gen', nil]
motor.each do |m|
    Sip::carga_semillas_sql(conexion, m, :cambios)
    Sip::carga_semillas_sql(conexion, m, :datos)
end

# Usuario inicial: sjrven con clave sjrven123
conexion.execute("INSERT INTO public.usuario 
	(nusuario, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
	VALUES ('sjrven', 'sjrven@localhost.org', 
	'$2a$10$uMAciEcJuUXDnpelfSH6He7BxW0yBeq6VMemlWc5xEl6NZRDYVA3G', 
	'', '2014-01-12', '2013-12-24', '2013-12-24', 1);")

