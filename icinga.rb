#!/usr/bin/env ruby

require 'open3'

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

# Step 1: Update the System
execute_command('sudo apt-get update -y && sudo apt-get upgrade -y')

# Step 2: Install LAMP stack and Pre-requisites
execute_command('sudo apt install apache2 -y')
execute_command('sudo systemctl enable apache2 && sudo systemctl start apache2')
execute_command('sudo apt-get install php8.1 php8.1-cli php8.1-common php8.1-imap php8.1-redis php8.1-snmp php8.1-xml php8.1-zip php8.1-mbstring php8.1-curl libapache2-mod-php -y')
execute_command('sudo apt-get install composer -y')
execute_command('composer require zendframework/zend-db')
execute_command('sudo apt-get install imagemagick -y')
execute_command('sudo apt install php-imagick -y')

# Install and Configure DB
execute_command('sudo apt-get install mariadb-server -y')
execute_command('sudo systemctl start mariadb && sudo systemctl enable mariadb')
execute_command('sudo apt-get install libmariadb-dev-compat libmariadb-dev -y')

# Step 3: Install Icinga 2
execute_command('sudo apt-get install icinga2 nagios-plugins -y')
execute_command('sudo service icinga2 start')
execute_command('sudo systemctl enable icinga2.service')
execute_command('sudo systemctl restart icinga2')
execute_command('sudo systemctl restart apache2')

# Verificar el usuario de API rootcon una contraseña generada automáticamente 
# en el archivo de configuración /etc/icinga2/conf.d/api-users.conf.
# Nos va a servir luego en icingaweb para configurar la API


# Step 5: Install Icingaweb2
execute_command('sudo icinga2 feature enable command')
execute_command('sudo service icinga2 restart')
execute_command('sudo groupadd icingacmd')
execute_command('sudo usermod -a -G icingacmd www-data')
execute_command('apt-get install icingaweb2 libapache2-mod-php icingacli -y')
execute_command('sudo icingacli setup config webserver apache --document-root /usr/share/icingaweb2/public')
execute_command('sudo service apache2 restart')

# Step 6: Install Icinga Director
execute_command('sudo apt install icinga-director')
