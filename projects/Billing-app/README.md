# Billing API 

The `Billing` API processes messages received through RabbitMQ. It parses JSON messages and creates entries in the `orders` database. Endpoints include:

- RabbitMQ Queue: `billing_queue`
