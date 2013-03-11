## Instalacion

1. Descargar la apliación
```bash
$ git clone https://github.com/pbruna/CarterApp.git
```

2. Copiar directorio contenido de directorio CarterApp a /home/carter/App/

3. Cambiar los permisos al usuario carter del directorio /home/carter/App/CarterApp
```bash
$ chown carter.carter -R /home/carter/App/CarterApp
```

4. Ejecutar como root:
```bash
$ rvm get head
$ rvm reload
```

5. Ejecutar como root:
```bash
$ rvm install 1.9.3
$ rvm use 1.9.3
$ rvm gemset create rails3
```

4. Como usuario carter y dentro del directorio /home/carter/App/CarterApp ejecutar:
```bash
$ bundle install
$ bundle install --binstubs
$ mkdir /home/carter/App/CarterApp/pids/
```


## Configuración

### Unicorn
Crear archivo /home/carter/App/CarterApp/config/unicorn.rb:
```
listen 8080, :tcp_nopush => true
worker_processes 2
working_directory "/home/carter/App/CarterApp/"
pid "/home/carter/App/CarterApp/pids/unicorn.pid"
stderr_path "/home/carter/App/CarterApp/log/unicorn_error.log"
timeout 30
preload_app true
```

### Servicio CarterAPP
Crear archivo /etc/init.d/CarterApp
```bash
#!/bin/sh
# description: CarterApp 
# processname: unicorn
# Author:       Patricio Bruna <pbruna@itlinux.cl> 
#
# chkconfig: - 98 02
#

. /etc/rc.d/init.d/functions
set -e
# Example init script, this can be used with nginx, too,
# since nginx and unicorn accept the same signals

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
APP_ROOT="/home/carter/App/CarterApp/"
APP_USER="carter"
PID="/home/carter/App/CarterApp/pids/unicorn.pid"
SET_RVM="rvm use ruby-1.9.3@rails3"
CMD="$SET_RVM && $APP_ROOT/bin/unicorn -D -c /home/carter/App/CarterApp/config/unicorn.rb -E production"
action="$1"
set -u

old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1

sig () {
        test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
        test -s $old_pid && kill -$1 `cat $old_pid`
}

case $action in
start)
        sig 0 && echo >&2 "Already running" && exit 0
        su -c "$CMD" - $APP_USER
        ;;
stop)
        sig QUIT && exit 0
        echo >&2 "Not running"
        ;;
force-stop)
        sig TERM && exit 0
        echo >&2 "Not running"
        ;;
restart|reload)
        sig HUP && echo reloaded OK && exit 0
        echo >&2 "Couldn't reload, starting '$CMD' instead"
        su -c "$CMD" - $APP_USER
        ;;
upgrade)
        if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
        then
                n=$TIMEOUT
                while test -s $old_pid && test $n -ge 0
                do
                        printf '.' && sleep 1 && n=$(( $n - 1 ))
                done
                echo

                if test $n -lt 0 && test -s $old_pid
                then
                        echo >&2 "$old_pid still exists after $TIMEOUT seconds"
                        exit 1
                fi
                exit 0
        fi
        echo >&2 "Couldn't upgrade, starting '$CMD' instead"
        su -c "$CMD" - $APP_USER
        ;;
reopen-logs)
        sig USR1
        ;;
*)
        echo >&2 "Usage: $0 <start|stop|restart|upgrade|force-stop|reopen-logs>"
        exit 1
        ;;
esac
```

### Configuración DB
Crear archivo /home/carter/App/CarterApp/config/mongoid.yml
```yaml
production:
  sessions:
    default:
      database: carterapp
      hosts:
        - localhost:27017
      options:
        consistency: :strong
  options:
```

### Nginx
```bash
$ cp /home/carter/App/CarterApp/config/carterapp_nginx.conf /etc/nginx/conf.d/
$ service nginx restart
```

### Subir servicio CarterApp
```bash
$ chmod +x /etc/init.d/CarterApp
$ service CarterApp restart
```

### Crear assets
Como usuario carter y en la raíz de la aplicación
```bash
$ RAILS_ENV=production rake assets:precompile
```

### Crear índices de la BD
Como usuario carter y en la raíz de la aplicación
```bash
$ RAILS_ENV=production rake db:mongoid:create_indexes
```


### Envío de Correos
El sistema envía varios correos con notificaciones. Para que los correos sean despachados correctamente se deben configurar las opciones del archivo ./config/initializers/smtp_config.rb.
En el software viene el archivo ./config/initializers/smtp_config.rb.sample que puede ser usado como ejemplo

### Creación de cuenta root
Cuando hablamos de cuenta nos referimos a la organización a la cual pertenecen los usuarios.
La cuenta root es una cuenta especial que sólo debe ser utilizada por la empresa que administra la plataforma CarterApp y da el servicio a otras empresas. Esta cuenta especial, y sus usuarios, cuentan con los siguiente privilegios:

* Pueden administrar otras cuentas no root,
* Pueden crear usuarios en las otras cuentas,
* Pueden acceder al información (registros) de las otras cuentas.

La idea de contar con estos privilegios es poder ayudar rápidamente a los usuarios del servicio Carter.

Para crear la **cuenta root** se debe ejecutar el siguiente comando en la raíz de la aplicación y seguir las instrucciones:

```bash
RAILS_ENV=production rake carter:create_admin_account
```
Una vez creada la cuenta y el primer usuario se puede utilizar la interfaz web para agregar más usuarios y cuentas.
