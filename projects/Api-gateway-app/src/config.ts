type EnvironmentVariables = {
  PORT: string | number
  PROXY_TARGET: string
  RABBITMQ_QUEUE_NAME: string
  RABBITMQ_HOST_ADDRESS: string
  INVENTORY_HOST?: string
}

const em: EnvironmentVariables = {
  PORT: process.env.API_GATEWAY_PORT || 3000,
  PROXY_TARGET: "http://localhost:8080",
  RABBITMQ_QUEUE_NAME: "billing_queue",
  RABBITMQ_HOST_ADDRESS: process.env.RABBITMQ_HOST_ADDRESS || "localhost",
}

if (process.env.INVENTORY_HOST) {
  em.PROXY_TARGET = `http://${process.env.INVENTORY_HOST}:8080`
}

export default Object.freeze(em)
