import variables from "./config/config"
import express from "express"
import cors from "cors"
import routes from "./routes/routes"
import controllers from "./controllers/movies"
import { Client } from "pg"

const {
  DATABASE_USER,
  DATABASE_PASSWORD,
  DATABASE_NAME,
  DATABASE_HOST,
  DATABASE_PORT,
  PORT,
} = variables

const app = express()

const config = {
  user: DATABASE_USER,
  host: DATABASE_HOST,
  database: DATABASE_NAME,
  password: DATABASE_PASSWORD,
  port: DATABASE_PORT,
}

const client = new Client(config)

client
  .connect()
  .then(() => {
    console.log("Connected to PostgreSQL database")
  })
  .catch((err) => {
    console.error("Error connecting to PostgreSQL database:", err.message)
    process.exit(1)
  })
  .finally(() => {
    client.end()
  })

app.use(cors(), express.json())
app.use("/api", routes(controllers))

app.listen(PORT, () => {
  console.log(`InventoryAPI app is running on port ${PORT}`)
})
