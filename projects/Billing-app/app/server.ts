import cfg from "./config"
import amqplib from "amqplib/callback_api"
import { createOrder } from "./orders"

amqplib.connect(`amqp://${cfg.RABBITMQ_HOST_ADDRESS}`, (err, conn) => {
  if (err) throw err

  conn.createChannel((err, channel) => {
    if (err) throw err

    channel.assertQueue(cfg.RABBITMQ_QUEUE_NAME)
    channel.consume(
      cfg.RABBITMQ_QUEUE_NAME,
      (msg) => {
        const acknowledge = () =>
          msg ? channel.ack(msg) : console.log("No acknowlege message")
        const notAcknowledge = () =>
          msg
            ? channel.nack(msg, false, false)
            : console.log("No notAcknowledge message")

        if (msg !== null) {
          try {
            const jsonData = JSON.parse(msg.content.toString())

            if (typeof jsonData === "object") {
              createOrder({ billing: jsonData, acknowledge, notAcknowledge })
            } else {
              throw new Error("Received message is not a JSON object.")
            }
          } catch (error) {
            console.error("Error:", error)
            notAcknowledge()
          }
        } else {
          console.log("Consumer cancelled by server")
        }
      },
      { noAck: false }
    )
  })
})
