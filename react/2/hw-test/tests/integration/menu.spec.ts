import test, { Page, expect } from '@playwright/test';
import { TEST_ID } from './_testids';

test('우하단 녹색 버튼을 누르면 메뉴가 뜬다', async ({ page }) => {
  await page.goto('/');
  await expect(page.getByTestId(TEST_ID['새 리뷰 버튼'])).not.toBeVisible();
  await expect(page.getByTestId(TEST_ID['새 과자 버튼'])).not.toBeVisible();

  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await expect(page.getByTestId(TEST_ID['새 리뷰 버튼'])).toBeVisible();
  await expect(page.getByTestId(TEST_ID['새 과자 버튼'])).toBeVisible();
});

test('우하단 녹색 버튼을 다시 누르면 메뉴가 사라진다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await expect(page.getByTestId(TEST_ID['새 리뷰 버튼'])).not.toBeVisible();
  await expect(page.getByTestId(TEST_ID['새 과자 버튼'])).not.toBeVisible();
});
