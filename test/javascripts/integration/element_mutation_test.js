import { test } from "@playwright/test"
import { assert } from "chai"

test.beforeEach(async ({ page }) => {
  await page.goto("/integration-tests")
})

test("test changing the element's text content re-processes the element", async ({ page }) => {
  await page.click("button#morph")

  await assertSingleUpdate(page, "#one")
  assert.equal(await page.textContent("#one"), "December 4, 2024")
})

test("test changing the element's datatime attribute re-processes the element", async ({ page }) => {
  await page.click("button#change-datetime")

  await assertSingleUpdate(page, "#one")
  assert.equal(await page.textContent("#one"), "December 4, 2015")
})

test("test changing the element's data-local attribute re-processes the element", async ({ page }) => {
  await page.click("button#change-relative")

  await assertSingleUpdate(page, "#one")
  assert.equal(await page.textContent("#one"), "on Dec 4, 2024")
})

test("test changing the element's data-format attribute re-processes the element", async ({ page }) => {
  await page.click("button#change-format")

  await assertSingleUpdate(page, "#one")
  assert.equal(await page.textContent("#one"), "Dec 4")
})

test("test changing the element's data-format24 attribute re-processes the element", async ({ page }) => {
  await page.click("button#change-format24")

  await assertSingleUpdate(page, "#one")
  assert.equal(await page.textContent("#one"), "December 4")
})

test("test changing an unlisted attribute does not re-process the element", async ({ page }) => {
  await page.click("button#change-foo")

  await assertNoUpdates(page, "#one")
})

test("test removing the element disconnects its mutation observer", async ({ page }) => {
  const isObserverPresent = await page.evaluate(() => LocalTime.getController().observations.size() !== 0)
  assert.isTrue(isObserverPresent, "The MutationObserver should be active")

  await page.click("button#remove")

  const isObserverGone = await page.evaluate(() => LocalTime.getController().observations.size() === 0)
  assert.isTrue(isObserverGone, "The MutationObserver should no longer be active")
})

test("test elements are only observed once", async ({ page }) => {
  await page.click("button#reprocess")
  await page.click("button#reprocess")
  await page.click("button#reprocess")

  const isSingleObserver = await page.evaluate(() => LocalTime.getController().observations.size() === 1)
  assert.isTrue(isSingleObserver, "There should only be one MutationObserver")
})

async function assertNoUpdates(page, selector) {
  assert.equal(await page.getAttribute(selector, "data-updates"), "0")
}

async function assertSingleUpdate(page, selector) {
  assert.equal(await page.getAttribute(selector, "data-updates"), "1")
}
