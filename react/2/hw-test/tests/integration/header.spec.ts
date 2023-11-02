import test, { expect } from '@playwright/test';
import { TEST_ID } from './_testids';

test('헤더 이미지를 클릭하면 와플스튜디오 홈페이지로 이동한다.', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['헤더 이미지']).click();
  await expect(page).toHaveURL('https://wafflestudio.com');
});

test('헤더 타이틀을 클릭하면 와플스튜디오 홈페이지로 이동한다.', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['제목']).click();
  await expect(page).toHaveURL('https://wafflestudio.com');
});

test('헤더의 리뷰 링크가 잘 작동한다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['과자']).click();
  await expect(page).toHaveURL('/snacks');
  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['리뷰']).click();
  await expect(page).toHaveURL('/');
});
