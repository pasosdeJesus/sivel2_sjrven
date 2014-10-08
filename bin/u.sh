#!/bin/sh
# Inicia produccion
if (test "${SECRET_KEY_BASE}" = "") then {
	echo "Definir variable de ambiente SECRET_KEY_BASE"
	exit 1;
} fi;
sudo su vtamara -c "cd /var/www/htdocs/sivel2_sjrven; rake assets:precompile; echo \"Iniciando unicorn...\"; SECRET_KEY_BASE=${SECRET_KEY_BASE} unicorn_rails -c config/unicorn.conf.minimal.rb  -E production -D"


  

