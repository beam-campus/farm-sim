FROM grafana/grafana

RUN uname

RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - \
  && apt-get install -y nodejs

RUN npm install -g yarn  \
    && yarn install \
    && npm run build


RUN grafana-cli plugins install couchdb-datasource

RUN service grafana-server restart


EXPOSE 3000