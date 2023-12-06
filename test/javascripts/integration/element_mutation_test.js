import { test } from "@playwright/test"
import { assert } from "chai"

test.beforeEach(async ({ page }) => {
  await page.goto("/integration-tests")
})

test("test changing the element's text content re-processes the element", async ({ page }) => {
  await page.click("button#morph")

  assert.equal(await page.textContent("#one"), "December 4, 2024")
  assert.equal(await page.getAttribute("#one", "data-updates"), "1")
})

test("test changing the element's datatime attribute re-processes the element", async ({ page }) => {
  await page.click("button#change-datetime")

  assert.equal(await page.textContent("#one"), "December 4, 2015")
  assert.equal(await page.getAttribute("#one", "data-updates"), "1")
})

test("test changing the element's data-local attribute re-processes the element", async ({ page }) => {
  await page.click("button#change-relative")

  assert.equal(await page.textContent("#one"), "on Dec 4, 2024")
  assert.equal(await page.getAttribute("#one", "data-updates"), "1")
})

test("test changing the element's data-format attribute re-processes the element", async ({ page }) => {
  await page.click("button#change-format")

  assert.equal(await page.textContent("#one"), "Dec 4")
  assert.equal(await page.getAttribute("#one", "data-updates"), "1")
})

test("test changing the element's data-format24 attribute re-processes the element", async ({ page }) => {
  await page.click("button#change-format24")

  assert.equal(await page.textContent("#one"), "December 4")
  assert.equal(await page.getAttribute("#one", "data-updates"), "1")
})

test("test changing an unlisted attribute does not re-process the element", async ({ page }) => {
  await page.click("button#change-foo")

  assert.equal(await page.getAttribute("#one", "data-updates"), "0")
})

test("test removing the element disconnects its mutation observer", async ({ page }) => {
  const isObserverPresent = await page.evaluate(() => LocalTime.getController().observedElements.size !== 0)
  assert.isTrue(isObserverPresent, "The MutationObserver should be active")

  await page.click("button#remove")

  const isObserverGone = await page.evaluate(() => LocalTime.getController().observedElements.size === 0)
  assert.isTrue(isObserverGone, "The MutationObserver should no longer be active")
})

test("test elements are only observed once", async ({ page }) => {
  await page.click("button#reprocess")
  await page.click("button#reprocess")
  await page.click("button#reprocess")

  const isSingleObserver = await page.evaluate(() => LocalTime.getController().observedElements.size === 1)
  assert.isTrue(isSingleObserver, "There should only be one MutationObserver")
})
