import co from "co"
import amqp from "amqplib"
import express from "express"
import variables from "./config"

const router = express.Router()
let channel: amqp.Channel
const MAX_CONNECTION_RETRIES: number = 0
const WAIT_BEFORE_RETRY = 5000

co(function* () {
  let currentRetry = 0
  while (
    currentRetry < MAX_CONNECTION_RETRIES ||
    MAX_CONNECTION_RETRIES === 0
  ) {
    try {
      const conn: amqp.Connection = yield amqp.connect(
        `amqp://${variables.RABBITMQ_HOST_ADDRESS}`
      )
      channel = yield conn.createChannel()
      channel.assertQueue(variables.RABBITMQ_QUEUE_NAME)
      
      console.info("RabbitMQ connected successfully")
      return
    } catch (err) {
      console.warn(
        `Error connecting to RabbitMQ (retry ${currentRetry + 1}${
          MAX_CONNECTION_RETRIES !== 0 ? "/" + MAX_CONNECTION_RETRIES : ""
        }):`,
        err
      )

      currentRetry++
      yield new Promise((resolve) => setTimeout(resolve, WAIT_BEFORE_RETRY))
    }
  }
}).catch((err) => {
  console.warn(err)
})

router.post("/", (req, res) => {
  try {
    if (!channel) {
      return
    }
    const message = JSON.stringify(req.body)
    channel.sendToQueue(variables.RABBITMQ_QUEUE_NAME, Buffer.from(message))
  } finally {
    res.status(201)
    res.end()
  }
})

export default router
