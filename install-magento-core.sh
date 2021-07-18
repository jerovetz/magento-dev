#!/bin/bash
rm -rf /var/www/html/magento
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/magento
cd /var/www/html/magento
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R :www-data .
chmod u+x bin/magento
