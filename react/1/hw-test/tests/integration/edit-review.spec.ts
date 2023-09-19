import test, { expect } from '@playwright/test';
import { TEST_ID } from './_testids';

test('리뷰 상자에 커서를 올리면 수정 버튼과 삭제 버튼이 나타난다', async ({ page }) => {
  await page.goto('/');
  const reviewItem = page.getByTestId(TEST_ID['리뷰']).nth(0);
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼'])).not.toBeVisible();
  await reviewItem.hover();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼'])).toBeVisible();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 삭제 버튼'])).toBeVisible();
});

test('수정 버튼을 누르면 리뷰의 내용을 수정할 수 있다 (수정 중 취소)', async ({ page }) => {
  await page.goto('/');
  const reviewItem = page.getByTestId(TEST_ID['리뷰']).nth(0);
  await reviewItem.hover();
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼']).click();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋'])).toHaveValue(
    '오동통통한 면과 동봉된 다시마가 맛있습니다',
  );
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋']).fill('수정된 리뷰');
  await page.getByTestId(TEST_ID['리뷰 수정 취소 버튼']).click();

  // 취소하면 수정한 게 날아간다
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼']).click();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋'])).toHaveValue(
    '오동통통한 면과 동봉된 다시마가 맛있습니다',
  );
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(2);
});

test('수정 버튼을 누르면 리뷰의 내용을 수정할 수 있다 (수정 중 완료)', async ({ page }) => {
  await page.goto('/');
  const reviewItem = page.getByTestId(TEST_ID['리뷰']).nth(0);
  await reviewItem.hover();
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼']).click();
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋']).fill('수정된 리뷰');
  await page.getByTestId(TEST_ID['리뷰 수정 저장 버튼']).click();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋'])).not.toBeVisible();
  await expect(reviewItem).toContainText('수정된 리뷰');
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(2);
});

test('하나가 수정 중이면 다른 것 수정 못한다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['리뷰']).nth(0).hover();
  await expect(page.getByTestId(TEST_ID['리뷰']).nth(0).getByTestId(TEST_ID['리뷰 수정 버튼'])).toBeVisible();
  await page.getByTestId(TEST_ID['리뷰']).nth(0).getByTestId(TEST_ID['리뷰 수정 버튼']).click();
  await page.getByTestId(TEST_ID['리뷰']).nth(1).hover();
  await expect(page.getByTestId(TEST_ID['리뷰']).nth(1).getByTestId(TEST_ID['리뷰 수정 버튼'])).not.toBeVisible();
});

test('삭제 버튼을 누르면 리뷰를 삭제할 수 있다 (삭제 중 취소)', async ({ page }) => {
  await page.goto('/');
  const reviewItem = page.getByTestId(TEST_ID['리뷰']).nth(0);
  await reviewItem.hover();
  await reviewItem.getByTestId(TEST_ID['리뷰 삭제 버튼']).click();
  await page.getByTestId(TEST_ID['리뷰 삭제 모달 취소 버튼']).click();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(2);
});

test('삭제 버튼을 누르면 리뷰를 삭제할 수 있다 (삭제 중 삭제)', async ({ page }) => {
  await page.goto('/');
  const reviewItem = page.getByTestId(TEST_ID['리뷰']).nth(0);
  await reviewItem.hover();
  await reviewItem.getByTestId(TEST_ID['리뷰 삭제 버튼']).click();
  await page.getByTestId(TEST_ID['리뷰 삭제 모달 삭제 버튼']).click();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(1);
});
