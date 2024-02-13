type EnvironmentVariables = {
  PORT: string | number
  DATABASE_USER: string
  DATABASE_PASSWORD: string
  DATABASE_NAME: string
  DATABASE_HOST: string
  DATABASE_PORT: number
}

const em: EnvironmentVariables = {
  PORT: process.env.INVENTORY_APP_PORT || 8080,
  DATABASE_USER: process.env.INVENTORY_DB_USER || "user",
  DATABASE_PASSWORD: process.env.INVENTORY_DB_PASSWORD || "secret",
  DATABASE_NAME: process.env.INVENTORY_DB_NAME || "db_name",
  DATABASE_HOST: process.env.INVENTORY_DB_HOST || "localhost",
  DATABASE_PORT: Number(process.env.DATABASE_PORT) || 5432,
}

export default Object.freeze(em)
