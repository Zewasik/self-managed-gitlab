import cfg from "./config"
import {Pool} from "pg"

const pool: Pool = new Pool({
  user: cfg.DATABASE_USER,
  host: cfg.DATABASE_HOST,
  database: cfg.DATABASE_NAME,
  password: cfg.DATABASE_PASSWORD,
  port: cfg.PORT,
})

export function createOrder(
  {billing: {number_of_items, total_amount, user_id} ,acknowledge, notAcknowledge}: CreateOrderProps
) {
  pool
    .query(
      "INSERT INTO orders(user_id, number_of_items, total_amount) VALUES($1, $2, $3)",
      [user_id, number_of_items, total_amount]
    )
    .then(acknowledge)
    .catch((err) => {
      console.log(err)
      notAcknowledge()
    })
}