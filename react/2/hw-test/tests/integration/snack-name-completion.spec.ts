import test, { Page, expect } from '@playwright/test';
import { TEST_ID } from './_testids';

test("과자 이름 인풋을 포커스하면 자동완성 목록이 뜬다", async ({ page }) => {
  await setupSnacks(page);
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);

  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).focus();
  const complList = reviewModal.getByTestId(TEST_ID['과자 이름 자동완성 리스트']);
  await expect(complList).toBeVisible();
  await expect(complList).toContainText("꼬깔콘 고소한맛");
  await expect(complList).toContainText("꼬북칩 초코츄러스맛");
  await expect(complList).toContainText("초코 바나나킥");
});

test("과자 이름을 입력하면 자동완성 목록이 바뀐다", async ({ page }) => {
  await setupSnacks(page);
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);

  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬');
  const complList = reviewModal.getByTestId(TEST_ID['과자 이름 자동완성 리스트']);
  await expect(complList).toContainText("꼬깔콘 고소한맛");
  await expect(complList).toContainText("꼬북칩 초코츄러스맛");
  await expect(complList).not.toContainText("초코 바나나킥");

  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).fill('초');
  await expect(complList).toContainText("초코 바나나킥");
  await expect(complList).toContainText("꼬북칩 초코츄러스맛");
  await expect(complList).not.toContainText("꼬깔콘 고소한맛");

  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬북');
  await expect(complList).toContainText("꼬북칩 초코츄러스맛");
  await expect(complList).not.toContainText("꼬깔콘 고소한맛");
  await expect(complList).not.toContainText("초코 바나나킥");
});

test("자동완성 목록에서 과자 이름을 클릭하면 과자 이름 인풋에 과자 이름이 채워진다", async ({ page }) => {
  await setupSnacks(page);
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬');
  const complList = reviewModal.getByTestId(TEST_ID['과자 이름 자동완성 리스트']);
  await complList.getByText('꼬북칩 초코츄러스맛').click();
  await expect(reviewModal.getByTestId(TEST_ID['과자 이름 인풋'])).toHaveValue('꼬북칩 초코츄러스맛');
  await expect(reviewModal.getByTestId(TEST_ID['과자 이름 자동완성 리스트'])).not.toBeVisible();
});

test("다른 인풋을 포커스하면 자동완성 목록이 사라진다", async ({ page }) => {
  await setupSnacks(page);
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await reviewModal.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬');
  const complList = reviewModal.getByTestId(TEST_ID['과자 이름 자동완성 리스트']);
  await expect(complList).toBeVisible();

  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋']).focus();
  await expect(complList).not.toBeVisible();
});

async function setupSnacks(page: Page) {
  const img_kokal =
    'https://contents.lotteon.com/itemimage/20231019072739/LM/88/01/06/28/61/90/3_/00/1/LM8801062861903_001_1.jpg/dims/optimize/dims/resizemc/400x400';
  const img_kobuk =
    'https://wafflestudio.com/images/icon_intro.svg?auto=format&fit=max&w=256';
  const img_banana =
    'https://wafflestudio.com/images/icon_intro.svg?auto=format&fit=max&w=256';

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
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 과자 버튼']).click();

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_banana);
  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('초코 바나나킥');
  await page.getByTestId(TEST_ID['추가 버튼']).click();

  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['리뷰']).click();
}
