chown -R 1000:1000 nifi registry // nifi's user:group
chmod -R 775 nifi registry
chmod -R g+s nifi registry
docker-compose down
docker-compose up -d