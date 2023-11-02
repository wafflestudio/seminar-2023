import test, { expect, Page } from '@playwright/test';
import { TEST_ID } from './_testids';

test('리뷰 상자에 커서를 올리면 수정 버튼과 삭제 버튼이 나타난다', async ({ page }) => {
  await setupReviews(page);
  const reviewItem = page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0);
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼'])).not.toBeVisible();
  await reviewItem.hover();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼'])).toBeVisible();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 삭제 버튼'])).toBeVisible();
});

test('수정 버튼을 누르면 리뷰의 내용을 수정할 수 있다 (수정 중 취소)', async ({ page }) => {
  await setupReviews(page);
  const reviewItem = page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0);
  await reviewItem.hover();
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼']).click();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋'])).toHaveValue('매운맛이 더 맛있다');
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋']).fill('수정된 리뷰');
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 취소 버튼']).click();

  // 취소하면 수정한 게 날아간다
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼']).click();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋'])).toHaveValue('매운맛이 더 맛있다');
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(2);
});

test('수정 버튼을 누르면 리뷰의 내용을 수정할 수 있다 (수정 중 완료)', async ({ page }) => {
  await setupReviews(page);
  const reviewItem = page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0);
  await reviewItem.hover();
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 버튼']).click();
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋']).fill('수정된 리뷰');
  await reviewItem.getByTestId(TEST_ID['리뷰 수정 저장 버튼']).click();
  await expect(reviewItem.getByTestId(TEST_ID['리뷰 수정 인풋'])).not.toBeVisible();
  await expect(reviewItem).toContainText('수정된 리뷰');
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(2);
});

test('하나가 수정 중이면 다른 것 수정 못한다', async ({ page }) => {
  await setupReviews(page);
  await page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0).hover();
  await expect(
    page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0).getByTestId(TEST_ID['리뷰 수정 버튼']),
  ).toBeVisible();
  await page
    .getByTestId(TEST_ID['리뷰 목록'])
    .getByTestId(TEST_ID['리뷰'])
    .nth(0)
    .getByTestId(TEST_ID['리뷰 수정 버튼'])
    .click();
  await page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(1).hover();
  await expect(
    page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(1).getByTestId(TEST_ID['리뷰 수정 버튼']),
  ).not.toBeVisible();
});

test('삭제 버튼을 누르면 리뷰를 삭제할 수 있다 (삭제 중 취소)', async ({ page }) => {
  await setupReviews(page);
  const reviewItem = page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0);
  await reviewItem.hover();
  await reviewItem.getByTestId(TEST_ID['리뷰 삭제 버튼']).click();
  await page.getByTestId(TEST_ID['리뷰 삭제 모달 취소 버튼']).click();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(2);
});

test('삭제 버튼을 누르면 리뷰를 삭제할 수 있다 (삭제 중 삭제)', async ({ page }) => {
  await setupReviews(page);
  const reviewItem = page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0);
  await reviewItem.hover();
  await reviewItem.getByTestId(TEST_ID['리뷰 삭제 버튼']).click();
  await page.getByTestId(TEST_ID['리뷰 삭제 모달 삭제 버튼']).click();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(1);
});

async function setupReviews(page: Page) {
  const img_kokal =
    'https://contents.lotteon.com/itemimage/20231019072739/LM/88/01/06/28/61/90/3_/00/1/LM8801062861903_001_1.jpg/dims/optimize/dims/resizemc/400x400';
  const img_kobuk =
    'https://wafflestudio.com/images/icon_intro.svg?auto=format&fit=max&w=256';
  const kokal = '꼬깔콘 고소한맛';

  await page.goto('/snacks/new');

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kokal);
  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬깔콘 고소한맛');
  await page.getByTestId(TEST_ID['추가 버튼']).click();

  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['리뷰']).click();

  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).fill(kokal);
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋']).fill('4');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋']).fill('맛있는 꼬깔콘이다');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();

  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();
  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).fill(kokal);
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋']).fill('3');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋']).fill('매운맛이 더 맛있다');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();

  await page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0).getByTestId(TEST_ID['과자 이름']).click();
}
