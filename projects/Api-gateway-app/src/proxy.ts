import variables from "./config"
import { createProxyMiddleware } from "http-proxy-middleware"

export const apiProxy = createProxyMiddleware("/api/movies", {
  target: variables.PROXY_TARGET,
  changeOrigin: true,
  proxyTimeout: 3000,
})

module.exports = {
  apiProxy,
}
