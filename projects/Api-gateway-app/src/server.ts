import variables from "./config"
import express, { Application } from "express"
import cors from "cors"
import { apiProxy } from "./proxy"
import fs from "fs"
import YAML from "yaml"
import swaggerUi from "swagger-ui-express"
import router from "./routes"
import swaggerYaml from "./swagger.yaml"

const app: Application = express()

const file = fs.readFileSync(swaggerYaml, "utf8")
const swaggerDocument = YAML.parse(file)

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument))

app.use(cors(), apiProxy)
app.use("/api/billing", express.json(), router)

app.listen(variables.PORT, () => {
  console.log(`GatewayAPI app is running on port ${variables.PORT}`)
})
