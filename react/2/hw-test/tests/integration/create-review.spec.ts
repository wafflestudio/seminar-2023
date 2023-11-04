import test, { Page, expect } from '@playwright/test';
import { TEST_ID } from './_testids';

const kokal = '꼬깔콘 고소한맛';

test('새 리뷰 버튼을 누르면 리뷰 쓰기 모달이 뜬다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await expect(reviewModal).toBeVisible();
});

test('모달이 뜨는 순간 리뷰의 내용은 비어있다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await expect(reviewModal.getByTestId(TEST_ID['과자 이름 인풋'])).toHaveValue('');
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋'])).toHaveValue('');
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋'])).toHaveAttribute('type', 'number');
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋'])).toHaveValue('');
});

test('리뷰의 내용을 작성하여 작성 버튼을 누르면 맨 위에 리뷰가 추가된다 (모두 입력)', async ({ page }) => {
  await setupSnacks(page);

  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, { name: kokal, rating: '4', content: 'content' });
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal).not.toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(1);
  const createdReview = page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0);
  await expect(createdReview).toContainText(kokal);
  await expect(createdReview).toContainText('content');
  await expect(createdReview).toContainText('4.0');
});

test('리뷰의 내용을 작성하여 작성 버튼을 눌렀을 때 평점이 오류면 안된다', async ({ page }) => {
  const errorMessage = '평점은 1 ~ 5 사이의 숫자로 써주세요';

  await setupSnacks(page);
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, { name: kokal, rating: '6', content: 'content' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 오류 메시지'])).toHaveText('');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 오류 메시지'])).toHaveText(errorMessage);
  await fillCreateReviewModal(page, { rating: null });
  await fillCreateReviewModal(page, { rating: '4' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 오류 메시지'])).toHaveText(errorMessage);

  await expect(reviewModal).toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(0);
});

test('리뷰의 내용을 작성하여 작성 버튼을 눌렀을 때 과자이름이 오류면 안된다', async ({ page }) => {
  const errorMessage = '해당 과자를 찾을 수 없습니다';

  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, {
    name: '고갈콘',
    rating: '4',
    content: 'conte',
  });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 오류 메시지'])).toHaveText('');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 오류 메시지'])).toHaveText(errorMessage);
  await fillCreateReviewModal(page, { name: null });
  await fillCreateReviewModal(page, { name: kokal });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 오류 메시지'])).toHaveText(errorMessage);

  await expect(reviewModal).toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(0);
});

test('리뷰의 내용을 작성하여 작성 버튼을 눌렀을 때 내용이 오류면 안된다', async ({ page }) => {
  const errorMessage = '첫글자와 끝글자가 공백이 아닌 5~1000자 문자열로 써주세요';

  await setupSnacks(page);
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, { name: kokal, rating: '4', content: '    cont    ' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 오류 메시지'])).toHaveText('');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 오류 메시지'])).toHaveText(errorMessage);
  await fillCreateReviewModal(page, { content: null });
  await fillCreateReviewModal(page, { content: '과자과자고' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 오류 메시지'])).toHaveText(errorMessage);

  await expect(reviewModal).toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(0);
});

test('오류 내용이 여러개일 경우 여러 오류가 모두 보인다', async ({ page }) => {
  await setupSnacks(page);
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();

  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 오류 메시지'])).toHaveText(
    '평점은 1 ~ 5 사이의 숫자로 써주세요',
  );
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 오류 메시지'])).toHaveText(
    '해당 과자를 찾을 수 없습니다',
  );
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 오류 메시지'])).toHaveText(
    '첫글자와 끝글자가 공백이 아닌 5~1000자 문자열로 써주세요',
  );
});

test('한 번 오류가 났어도 고치면 작성된다', async ({ page }) => {
  await setupSnacks(page);
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 리뷰 버튼']).click();

  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, { name: kokal, rating: '4', content: '' });
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await fillCreateReviewModal(page, { content: '과자과자고' });
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal).not.toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(1);
  const createdReview = page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0);
  await expect(createdReview).toContainText(kokal);
  await expect(createdReview).toContainText('과자과자고');
  await expect(createdReview).toContainText('4.0');
});

test('리뷰의 내용을 작성하여 작성 버튼을 누르면 맨 위에 리뷰가 추가된다 (이미지 미입력)', async ({ page }) => {
  test.skip(); // 이 시나리오는 보너스 스펙을 구현한 사람을 위해 테스트하지 않는다
});

const fillCreateReviewModal = async (
  page: Page,
  { name, rating, content }: Partial<{ name: string | null; rating: string | null; content: string | null }>,
) => {
  const modal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  if (typeof name === 'string') await modal.getByTestId(TEST_ID['과자 이름 인풋']).fill(name);
  if (name === null) await modal.getByTestId(TEST_ID['과자 이름 인풋']).clear();
  if (typeof rating === 'string') await modal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋']).fill(rating);
  if (rating === null) await modal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋']).clear();
  if (typeof content === 'string') await modal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋']).fill(content);
  if (content === null) await modal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋']).clear();
};

async function setupSnacks(page: Page) {
  const img_kokal =
    'https://contents.lotteon.com/itemimage/20231019072739/LM/88/01/06/28/61/90/3_/00/1/LM8801062861903_001_1.jpg/dims/optimize/dims/resizemc/400x400';
  const img_kobuk =
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
}
