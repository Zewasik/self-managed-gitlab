type EnvironmentVariables = {
    PORT: number
    RABBITMQ_QUEUE_NAME: string
    RABBITMQ_HOST_ADDRESS: string
    DATABASE_USER: string
    DATABASE_PASSWORD: string
    DATABASE_NAME: string
    DATABASE_HOST: string
  }

type CreateOrderProps = {
    billing: {
        user_id: number,
        number_of_items: number,
        total_amount: number,
    },
    acknowledge: ()=>void,
    notAcknowledge: ()=>void
}