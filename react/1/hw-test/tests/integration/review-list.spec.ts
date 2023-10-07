import test, { expect } from '@playwright/test';
import { TEST_ID } from './_testids';

test('디폴트 내용이 잘 보인다', async ({ page }) => {
  await page.goto('/');
  const reviewItem = page.getByTestId(TEST_ID['리뷰']).nth(1);
  await expect(reviewItem).toContainText('맥콜');
  await expect(reviewItem.getByTestId('snack-image')).toHaveAttribute(
    'src',
    'https://img.danawa.com/prod_img/500000/350/174/img/3174350_1.jpg?shrink=330:*&_v=20220421104604',
  );
  await expect(reviewItem).toContainText('4.0');
  await expect(reviewItem).toContainText('보리차와 콜라가 반반 섞인 듯한 맛이 독특합니다.');
});
