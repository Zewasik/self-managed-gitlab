import { Request, Response } from "express"
import variables from "../config/config"
import { Pool } from "pg"

const {
  DATABASE_USER,
  DATABASE_PASSWORD,
  DATABASE_NAME,
  DATABASE_HOST,
  DATABASE_PORT,
} = variables

const pool = new Pool({
  user: DATABASE_USER,
  host: DATABASE_HOST,
  database: DATABASE_NAME,
  password: DATABASE_PASSWORD,
  port: DATABASE_PORT,
})

interface Movie {
  id: number
  title: string
  description: string
}

interface TitleQuery {
  title?: string
}

interface IdQuery {
  id?: string
}

function getAllMovies(req: Request<TitleQuery>, res: Response<Movie[]>) {
  const title = `%${req.query.title || ""}%`

  pool
    .query<Movie>("SELECT * FROM movies WHERE title ILIKE $1", [title])
    .then((result) => res.json(result.rows))
    .catch((err) => {
      console.log(err)
      res.status(500)
    })
    .finally(() => res.end())
}

function deleteAllMovies(req: Request, res: Response) {
  pool
    .query("DELETE FROM movies")
    .catch((err) => {
      console.log(err)
      res.status(500)
    })
    .finally(() => res.end())
}

function createMovie(req: Request<object, null, Movie>, res: Response<Movie>) {
  const { title, description } = req.body

  pool
    .query<Movie>(
      "INSERT INTO movies(title, description) VALUES($1, $2) RETURNING id, title, description",
      [title, description]
    )
    .then((result) => {
      res.status(201)
      res.json(result.rows[0])
    })
    .catch((err) => {
      console.log(err)
      res.status(500)
    })
    .finally(() => res.end())
}

function getMovieById(req: Request<IdQuery>, res: Response<Movie>) {
  const { id } = req.params

  pool
    .query<Movie>("SELECT * FROM movies WHERE id = $1", [id])
    .then((result) => {
      if (result.rowCount == 0) {
        res.status(404)
        return
      }
      res.json(result.rows[0])
    })
    .catch((err) => {
      console.log(err)
      res.status(500)
    })
    .finally(() => res.end())
}

function updateMovieById(
  req: Request<IdQuery, null, Movie>,
  res: Response<Movie>
) {
  const { id } = req.params

  const setClause: string[] = []
  const values: (string | number)[] = [Number(id)]

  Object.entries(req.body).forEach(
    ([key, value]: [string, string | number]) => {
      setClause.push(`${key} = $${setClause.length + 2}`)
      values.push(value)
    }
  )

  pool
    .query<Movie>(
      `UPDATE movies SET ${setClause.join(
        ", "
      )} WHERE id = $1 RETURNING id, title, description`,
      values
    )
    .then((result) => {
      if (result.rowCount == 0) {
        res.status(404)
        return
      }
      res.json(result.rows[0])
    })
    .catch((err) => {
      console.log(err)
      res.status(500)
    })
    .finally(() => res.end())
}

function deleteMovieById(req: Request<IdQuery>, res: Response) {
  const { id } = req.params

  pool
    .query(`DELETE FROM movies WHERE id = $1`, [id])
    .then((result) => {
      if (result.rowCount == 0) {
        res.status(404)
        return
      }
      res.status(204)
    })
    .catch((err) => {
      console.log(err)
      res.status(500)
    })
    .finally(() => res.end())
}

export default {
  getAllMovies,
  createMovie,
  deleteAllMovies,
  getMovieById,
  updateMovieById,
  deleteMovieById,
}
