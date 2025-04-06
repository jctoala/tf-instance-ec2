#!/bin/bash
# Actualiza el sistema e instala Apache
yum update -y
yum install -y httpd

# Habilita Apache para que inicie con el sistema
systemctl enable httpd
systemctl start httpd

# Escribe el archivo index.html con un mensaje de bienvenida
echo "<h1>¡Hola Mundo desde mi servidor web!</h1>" > /var/www/html/index.html
