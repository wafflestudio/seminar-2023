import test, { expect } from '@playwright/test';

test('헤더 이미지를 클릭하면 와플스튜디오 홈페이지로 이동한다.', async ({
  page,
}) => {
  await page.goto('/');
  await page.getByTestId('header').getByTestId('waffle-logo').click();
  await expect(page).toHaveURL('https://wafflestudio.com');
});
