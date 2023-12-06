import { devices } from "@playwright/test"

const config = {
  projects: [
    {
      name: "chrome",
      use: {
        ...devices["Desktop Chrome"],
        contextOptions: {
          timeout: 5000
        }
      }
    },
    {
      name: "firefox",
      use: {
        ...devices["Desktop Firefox"],
        contextOptions: {
          timeout: 5000
        }
      }
    },
    {
      name: "webkit",
      use: {
        ...devices["Desktop Safari"],
        contextOptions: {
          timeout: 5000
        }
      }
    }
  ],
  browserStartTimeout: 60000,
  testDir: "./test/javascripts/",
  testMatch: /integration\/.*_test\.js/,
  webServer: {
    command: "yarn start"
  },
  use: {
    baseURL: "http://localhost:9000/"
  }
}

export default config
