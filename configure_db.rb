#!/usr/bin/env ruby

require 'open3'
require 'mysql2'

def execute_command(command)
  puts "Executing: #{command}"
  Open3.popen2e(command) do |stdin, stdout_and_stderr, wait_thr|
    while line = stdout_and_stderr.gets
      puts line
    end

    exit_status = wait_thr.value
    unless exit_status.success?
      abort "Command '#{command}' failed"
    end
  end
end

# Install and Configure DB
execute_command('sudo apt-get install mariadb-server -y')
execute_command('sudo systemctl start mariadb && sudo systemctl enable mariadb')
execute_command('sudo apt-get install libmariadb-dev-compat libmariadb-dev')
execute_command('sudo apt-get install icinga2-ido-mysql -y')
execute_command('gem install --user-install mysql2')

def connect_db
    begin
        # Conexión al servidor MariaDB
        client = Mysql2::Client.new(
          :host => "localhost",
          :username => "root",
          :password => "icinga"
        )
        
        # Crear una nueva base de datos
        client.query("CREATE DATABASE IF NOT EXISTS icinga2")
        
        # Crear un nuevo usuario
        client.query("GRANT ALL PRIVILEGES ON *.* TO 'icinga'@'localhost'")

        # Aplicar los cambios
        client.query("FLUSH PRIVILEGES")
        
        # Otorgar todos los privilegios al nuevo usuario para la nueva base de datos
        client.query("GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icinga2.* TO 'icinga'@'localhost' IDENTIFIED BY 'icinga'")
        
        # Aplicar los cambios
        client.query("FLUSH PRIVILEGES")
      
      rescue Mysql2::Error => e
        puts "Error durante la ejecución: #{e.message}"
      ensure
        # Cerrar la conexión
        client.close if client
    end
end

connect_db

=begin
Configuracion Manual de las bases de datos

*** Aseguramos la instalación ***
sudo /usr/bin/mysql_secure_installation


**** ICINGA CORE ****

- Instalamos IDO
sudo apt-get install icinga2-ido-mysql

- LOGIN mariadb o mysql
sudo mysql -u root -p

- CREAMOS la base
CREATE DATABASE icinga2;
GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icinga2.* TO 'icinga'@'localhost' IDENTIFIED BY 'icinga';
FLUSH PRIVILEGES;
EXIT;

- SCHEMA
sudo mysql -u root -p icinga2 < /usr/share/icinga2-ido-mysql/schema/mysql.sql
sudo icinga2 feature enable ido-mysql
sudo service icinga2 restart

**** ICINGAWEB2 ****
sudo icinga2 feature enable command
sudo service icinga2 restart

- LOGIN mariadb o mysql
sudo mysql -u root -p

CREATE DATABASE icingaweb2;
EXIT;

sudo mysql -u root -p icingaweb2 < /usr/share/doc/icingaweb2/schema/mysql.schema.sql

**** ICINGA DIRECTOR ****

- LOGIN mariadb o mysql
sudo mysql -u root -p

mysql -e "CREATE DATABASE director CHARACTER SET 'utf8';
  CREATE USER director@localhost IDENTIFIED BY 'CHANGEME';
  GRANT ALL ON director.* TO director@localhost;"

=end