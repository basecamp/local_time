import { Router } from "express"
import express from "express"
import path from "path"
import * as url from 'url'

const __dirname = url.fileURLToPath(new URL('.', import.meta.url));
const router = Router()

router.get("/", (_request, response) => {
  const fixture = path.join(__dirname, "./fixtures/index.html")
  response.status(200).sendFile(fixture)
})

router.get("/time-zone-check", (_request, response) => {
  const fixture = path.join(__dirname, "./fixtures/time_zone_check.html")
  response.status(200).sendFile(fixture)
})

router.get("/test-build", (_request, response) => {
  const file = path.join(__dirname, "./builds/index.js")
  response.status(200).sendFile(file)
})

router.get("/current-build", (_request, response) => {
  const file = path.join(__dirname, "./../../app/assets/javascripts/local-time.es2017-umd.js")
  response.status(200).sendFile(file)
})

const app = express()
app.use(express.static("."))
app.use(router)

const port = parseInt(process.env.PORT || "9000")
app.listen(port, () => {
  console.log(`
    /*
      Please go to http://localhost:${port}/ to run JS tests now.
      Or go to http://localhost:${port}/time-zone-check to manually test a time zone.
    */
  `)
})
