FROM postgres:13.9-alpine

WORKDIR /docker-entrypoint-initdb.d

COPY ./sql/init_billing.sql ./
