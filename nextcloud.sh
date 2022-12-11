version: '3'

services:
  db:
    image: mariadb:10.5
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    restart: always
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=
      - MARIADB_AUTO_UPGRADE=1
      - MARIADB_DISABLE_UPGRADE_BACKUP=1
    env_file:
      - db.env

  redis:
    image: redis:alpine
    restart: always

  app:
    image: nextcloud:apache
    restart: always
    ports:
      - 80:80
    volumes:
      - nextcloud:/var/www/html
    environment:
      - MYSQL_HOST=db
      - REDIS_HOST=redis
    env_file:
      - db.env
    depends_on:
      - db
      - redis

  cron:
    image: nextcloud:apache
    restart: always
    volumes:
      - nextcloud:/var/www/html
    entrypoint: /cron.sh
    depends_on:
      - db
      - redis

volumes:
  db:
  nextcloud:
