
| Comando               | Descripción                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `terraform init`       | Inicializa un directorio de trabajo con archivos de configuración de Terraform. Descarga los proveedores necesarios. |
| `terraform plan`       | Genera y muestra un plan de ejecución que detalla las acciones que Terraform realizará para alcanzar el estado deseado. |
| `terraform apply`      | Aplica los cambios necesarios para alcanzar el estado deseado definido en las configuraciones. |
| `terraform destroy`    | Elimina todos los recursos creados por la configuración de Terraform.       |
| `terraform refresh`    | Actualiza el estado con respecto a los recursos reales, sin realizar cambios. |
| `terraform validate`   | Valida los archivos de configuración de Terraform para detectar errores de sintaxis. |
| `terraform show`       | Muestra el estado o el plan de ejecución en un formato legible.              |
| `terraform output`     | Muestra los valores de salida definidos en las configuraciones de Terraform. |
| `terraform import`     | Importa recursos existentes en el estado de Terraform.                      |
| `terraform state`      | Permite manipular el estado, como mover recursos o eliminar elementos.      |
| `terraform fmt`        | Formatea los archivos de configuración de Terraform de acuerdo con las convenciones estándar. |
| `terraform taint`      | Marca un recurso para su recreación en la próxima ejecución de `apply`.      |
| `terraform untaint`    | Desmarca un recurso marcado previamente con `taint` para su recreación.     |
| `terraform workspace`  | Gestiona los entornos de trabajo, permitiendo tener múltiples estados en el mismo directorio de configuración. |
| `terraform providers`  | Lista los proveedores utilizados en la configuración y sus versiones.       |
| `terraform graph`      | Genera un gráfico visual de los recursos gestionados por Terraform.         |
| `terraform console`    | Abre una consola interactiva para evaluar y probar expresiones.             |
| `terraform apply -auto-approve` | Aplica cambios automáticamente sin necesidad de confirmación.      |
