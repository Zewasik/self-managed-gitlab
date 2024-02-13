import express, { RequestHandler } from "express"
const router = express.Router()

interface Controllers {
  getAllMovies: RequestHandler
  createMovie: RequestHandler
  deleteAllMovies: RequestHandler
  getMovieById: RequestHandler
  updateMovieById: RequestHandler
  deleteMovieById: RequestHandler
}

export default function routes(controllers: Controllers) {
  router.get("/movies", controllers.getAllMovies)
  router.post("/movies", controllers.createMovie)
  router.delete("/movies", controllers.deleteAllMovies)

  router.get("/movies/:id", controllers.getMovieById)
  router.put("/movies/:id", controllers.updateMovieById)
  router.delete("/movies/:id", controllers.deleteMovieById)

  return router
}
