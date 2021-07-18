# Magento-dev

This is a configured image for developing Magento plugins, based on official PHP image (https://hub.docker.com/_/php) with an already added Apache server.
Usage:

    docker run -d -v <your desired magento install location>:/var/www/html -p 8080:80 --name magento-dev jurijuri/magento-dev

then you can install a fresh latest magento:

    docker exec -it magento-dev /usr/local/bin/install-magento-core.sh

Now you should setup the app, here is the documentation: https://devdocs.magento.com/guides/v2.4/install-gde/composer.html#install-magento
You should provide an elastic and a mysql instance with an already created empty database.
If app setup is ready disable the twofactor authentication plugin:

    bin/magento module:disable Magento_TwoFactorAuth

Here is a Docker compose yml example for a complete stack:

    services:
      magento:
        image: jurijuri/magento-dev
        volumes:
          - ./.magento:/var/www/html
    #     - ./src:/src <- I also mount my plugin source, and soft link it under /app/code in the container, and change permissions/ownership of plugin directory
        ports:
          - "8090:80"

      mysql:
        image: mysql:8
        command: --default-authentication-plugin=mysql_native_password
        volumes:
          - dbdata:/var/lib/mysql
        environment:
          MYSQL_ROOT_PASSWORD: example
          MYSQL_DATABASE: test

      elastic:
         image: elasticsearch:7.5.2
        environment:
          discovery.type: single-node
        volumes:
           - elasticdata:/usr/share/elasticsearch/data

    volumes:
      dbdata:
      elasticdata:

This is not a production-grade image, my goal was to create a fast and working local development environment.






