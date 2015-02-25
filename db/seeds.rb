# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

connection = ActiveRecord::Base.connection();

# De motor SIVeL generico
l = File.readlines(
  Gem.loaded_specs['sivel2_gen'].full_gem_path + "/db/datos-basicas.sql"
)
connection.execute(l.join("\n"))

# De motor SIVeL SJR
l = File.readlines(Gem.loaded_specs['sivel2_sjr'].full_gem_path +
                   "/db/datos-basicasn.sql")
connection.execute(l.join("\n"));

# De este
l = File.readlines("db/datos-basicasp.sql")
connection.execute(l.join("\n"));


# Usuario inicial: sjrven con clave sjrven123
connection.execute("INSERT INTO usuario 
	(nusuario, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
	VALUES ('sjrven', 'sjrven@localhost.org', 
	'$2a$10$uMAciEcJuUXDnpelfSH6He7BxW0yBeq6VMemlWc5xEl6NZRDYVA3G', 
	'', '2014-01-12', '2013-12-24', '2013-12-24', 1);")

