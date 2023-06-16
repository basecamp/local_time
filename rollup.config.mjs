import * as url from 'url'
import coffee from "rollup-plugin-coffee-script"
import terser from '@rollup/plugin-terser'
import alias from '@rollup/plugin-alias'
import { nodeResolve } from "@rollup/plugin-node-resolve"

const __dirname = url.fileURLToPath(new URL('.', import.meta.url))

export default [
  {
    input: "lib/assets/javascripts/src/local-time/index.coffee",
    context: "window",
    output: [
      {
        name: "LocalTime",
        file: "app/assets/javascripts/local-time.es2017-umd.js",
        format: "umd"
      },
      {
        file: "app/assets/javascripts/local-time.es2017-esm.js",
        format: "es"
      }
    ],
    plugins: [
      coffee(),
      nodeResolve({ extensions: [".coffee"] }),
      terser()
    ],
    watch: {
      include: "lib/assets/javascripts/src/local-time/**"
    }
  },
  {
    input: "test/javascripts/src/index.coffee",
    context: "window",
    output: {
      file: "test/javascripts/builds/index.js",
      format: "iife"
    },
    plugins: [
      alias({
        entries: {
          "local_time": `${__dirname}/app/assets/javascripts/local-time.es2017-esm.js`,
          "moment": `${__dirname}/test/javascripts/vendor/moment.js`,
          "sinon": `${__dirname}/test/javascripts/vendor/sinon.js`
        }
      }),
      coffee(),
      nodeResolve({ extensions: [".coffee"] })
    ],
    watch: {
      include: "test/javascripts/src/**"
    }
  }
]
