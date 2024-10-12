```
cp .env.example .env
nano .env
cp config/database.yml.enc config/database.yml
nano config/database.yml


docker compose up --build -d
```
```
docker exec booking-flight-web bundle install
docker exec booking-flight-web bundle exec rake db:migrate
docker exec booking-flight-web bundle exec rake db:seed
docker exec booking-flight-web bundle exec pumactl phased-restart
```
```
docker exec -it booking-flight-db bash

mysql -u ... -p
```
