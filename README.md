## Configuración

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