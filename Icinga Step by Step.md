# Instalacion
```bash
sudo apt-get install ruby ruby-dev
```
Para instalar icinga debemos correr el Script repo_list.rb para agregar el repositorio de forma automatica
```bash
sudo ruby repo_list.rb
```
Luego de eso debemos ejecutar el script icinga2.rb para realizar la instalacion de icinga2, icingaweb2 y ademas icinga-director.
```bash
sudo ruby icinga2.rb
```
Configuramos luego el idioma de PHP

Después de todo esto, deberemos configurar la zona horaria adecuada para su máquina, lo que puede determinarse a partir de la página web oficial de PHP. 

Para ellos editaremos el fichero php.ini
```bash
sudo vi /etc/php/8.1/apache2/php.ini
```
Buscaremos la siguiente línea (Ponemos "/" y "date.timezone")
```bash
;date.timezone =
```
Le agregamos:  America/Argentina/Buenos_Aires

Guardaremos el fichero
```bash
:wq!
```
Y reiniciaremos el servicio de apache
```bash
sudo service apache2 restart
```
Una vez configurado todo debemos realizar la configuracion de icingaweb desde la url http://localhost/icingaweb2/setup

Creamos el token y lo usamos
```bash
sudo icingacli token create
```
![Untitled](img/Untitled.png)

Luego habilitamos el Modulo de monitoreo

![Untitled](img/Untitled%201.png)

En el siguiente paso hace un chequeo de las dependencias que debe usar la aplicacion, por lo cual debemos validar que este todo **EN VERDE**

![Untitled](img/Untitled%202.png)

![Untitled](img/Untitled%203.png)

En el caso de encontrar algun inconveniente, hay que subsanarlo antes de continuar.

Luego podemos elegir la Fuente de la Autenticacion, que puede ser por Base de datos, LDAP o algun otro servicio externo.

![Untitled](img/Untitled%204.png)

Configuracion la conexion, podemos validarla antes de darle NEXT.

![Untitled](img/Untitled%205.png)

Database Resource

![Untitled](img/Untitled%206.png)

Authenticacion Backend

![Untitled](img/Untitled%207.png)

Seteamos el usuario de ADMIN web

![Untitled](img3/Untitled%208.png)

Aplicamos la configuracion por defecto

![Untitled](img/Untitled%209.png)

NEXT

![Untitled](img/Untitled%2010.png)

NEXT

![Untitled](img/Untitled%2011.png)

Configuramos los datos de la base Backend

![Untitled](img/Untitled%2012.png)

Configuramos el Command Transport

![Untitled](img/Untitled%2013.png)

NEXT

![Untitled](img/Untitled%2014.png)

NEXT

![Untitled](img/Untitled%2015.png)

FINISH

![Untitled](img/Untitled%2016.png)

![Untitled](img/Untitled%2017.png)

![Untitled](img/Untitled%2018.png)