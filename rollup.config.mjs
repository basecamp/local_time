import coffee from "rollup-plugin-coffee-script"
import terser from '@rollup/plugin-terser'
import { nodeResolve } from "@rollup/plugin-node-resolve"

const year = new Date().getFullYear()
const banner = `/*\nLocalTime ${process.env.npm_package_version}\nCopyright © ${year} 37signals LLC\n*/`

export default [
  {
    input: "lib/assets/javascripts/src/local-time/index.coffee",
    context: "window",
    output: [
      {
        name: "LocalTime",
        file: "app/assets/javascripts/local-time.es2017-umd.js",
        format: "umd",
        banner
      },
      {
        file: "app/assets/javascripts/local-time.es2017-esm.js",
        format: "es",
        banner
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
  }
]
