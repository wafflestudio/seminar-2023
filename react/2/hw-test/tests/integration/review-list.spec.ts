import test, { expect, Page } from '@playwright/test';
import { TEST_ID } from './_testids';

test('리뷰에서 과자 이름을 클릭하면 해당 과자의 페이지로 이동한다', async ({ page }) => {
  await setupReviews(page);

  await page.getByText('꼬깔콘 고소한맛').click();
  expect(page).toHaveURL(/snacks\/\d+/);

  await expect(page.getByTestId(TEST_ID['과자 카드']).getByTestId(TEST_ID['과자 이름'])).toHaveText('꼬깔콘 고소한맛');
});

test('과자 목록에서 과자 이름을 클릭하면 해당 과자의 페이지로 이동한다', async ({ page }) => {
  await setupSnacks(page);

  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['과자']).click();
  await page.getByText('꼬깔콘 고소한맛').click();
  expect(page).toHaveURL(/snacks\/\d+/);

  await expect(page.getByTestId(TEST_ID['과자 카드']).getByTestId(TEST_ID['과자 이름'])).toHaveText('꼬깔콘 고소한맛');
});

async function setupSnacks(page: Page) {
  const img_kokal =
    'https://contents.lotteon.com/itemimage/20231019072739/LM/88/01/06/28/61/90/3_/00/1/LM8801062861903_001_1.jpg/dims/optimize/dims/resizemc/400x400';
  const img_kobuk =
    'https://wafflestudio.com/images/icon_intro.svg?auto=format&fit=max&w=256';
  const kokal = '꼬깔콘 고소한맛';
  const kobuk = '꼬북칩 초코츄러스맛';

  await page.goto('/snacks/new');

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kokal);
  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬깔콘 고소한맛');
  await page.getByTestId(TEST_ID['추가 버튼']).click();

  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['리뷰']).click();
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 과자 버튼']).click();

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kobuk);
  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬북칩 초코츄러스맛');
  await page.getByTestId(TEST_ID['추가 버튼']).click();

  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['리뷰']).click();
}

async function setupReviews(page: Page) {
  const kokal = '꼬깔콘 고소한맛';
  const kobuk = '꼬북칩 초코츄러스맛';

  await setupSnacks(page);
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).fill(kokal);
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋']).fill('4');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋']).fill('맛있는 꼬깔콘이다');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();

  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();
  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).fill(kobuk);
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋']).fill('5');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋']).fill('더 맛있는 꼬북칩이다');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
}
