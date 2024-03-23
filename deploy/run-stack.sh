#! /bin/bash
sudo mkdir -p /volume/couchdb/log
sudo mkdir -p /volume/couchdb/data
sudo mkdir -p /volume/couchdb/config

sudo mkdir -p /volume/eventstore/logs
sudo mkdir -p /volume/eventstore/data
sudo mkdir -p /volume/eventstore/index

sudo mkdir -p /volume/grafana/data
sudo mkdir -p /volume/fluentd/data



sudo mkdir -p /volume/elastic/data
# sudo mkdir -p /volume/elastic/data01
# sudo mkdir -p /volume/elastic/data02
# sudo mkdir -p /volume/elastic/data03



sudo chown $USER -R /volume/

git submodule update --remote

docker-compose down
docker-compose up --build $1 