import test, { Page, expect } from '@playwright/test';
import { TEST_ID } from './_testids';

const mockImage = 'https://wafflestudio.com/images/icon_intro.svg';

test('우하단의 녹색 버튼을 누르면 리뷰 쓰기 모달이 뜬다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await expect(reviewModal).toBeVisible();
});

test('모달이 뜨는 순간 리뷰의 내용은 비어있다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 이미지 인풋'])).toHaveValue('');
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 인풋'])).toHaveValue('');
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋'])).toHaveValue('');
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋'])).toHaveAttribute('type', 'number');
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋'])).toHaveValue('');
});

test('리뷰의 내용을 작성하여 작성 버튼을 누르면 맨 위에 리뷰가 추가된다 (모두 입력)', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, { image: mockImage, name: 'snack', rating: '4', content: 'content' });
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal).not.toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(3);
  const createdReview = page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0);
  await expect(createdReview).toContainText('snack');
  await expect(createdReview).toContainText('content');
  await expect(createdReview).toContainText('4.0');
  await expect(createdReview.locator('img')).toHaveAttribute('src', mockImage);
});

test('리뷰의 내용을 작성하여 작성 버튼을 눌렀을 때 평점이 오류면 안된다', async ({ page }) => {
  const errorMessage = '평점은 1 ~ 5 사이의 숫자로 써주세요';
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, { image: mockImage, name: 'snack', rating: '6', content: 'content' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 오류 메시지'])).toHaveText('');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 오류 메시지'])).toHaveText(errorMessage);
  await fillCreateReviewModal(page, { rating: null });
  await fillCreateReviewModal(page, { rating: '4' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 평점 오류 메시지'])).toHaveText(errorMessage);

  await expect(reviewModal).toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(2);
});

test('리뷰의 내용을 작성하여 작성 버튼을 눌렀을 때 과자이름이 오류면 안된다', async ({ page }) => {
  const errorMessage = '첫글자와 끝글자가 공백이 아닌 1~20자 문자열로 써주세요';
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, { name: 'asdfasdfasdfasdfasdfasdf', rating: '4', content: 'conte' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 오류 메시지'])).toHaveText('');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 오류 메시지'])).toHaveText(errorMessage);
  await fillCreateReviewModal(page, { name: null });
  await fillCreateReviewModal(page, { name: '과자' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 오류 메시지'])).toHaveText(errorMessage);

  await expect(reviewModal).toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(2);
});

test('리뷰의 내용을 작성하여 작성 버튼을 눌렀을 때 내용이 오류면 안된다', async ({ page }) => {
  const errorMessage = '첫글자와 끝글자가 공백이 아닌 5~1000자 문자열로 써주세요';
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, { name: 'asdf', rating: '4', content: '    cont    ' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 오류 메시지'])).toHaveText('');
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 오류 메시지'])).toHaveText(errorMessage);
  await fillCreateReviewModal(page, { content: null });
  await fillCreateReviewModal(page, { content: '과자과자고' });
  await expect(reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 내용 오류 메시지'])).toHaveText(errorMessage);

  await expect(reviewModal).toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(2);
});

test('한 번 오류가 났어도 고치면 작성된다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  const reviewModal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  await fillCreateReviewModal(page, { name: 'asdf', rating: '4', content: '' });
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await fillCreateReviewModal(page, { content: '과자과자고' });
  await reviewModal.getByTestId(TEST_ID['리뷰 작성 모달 작성 버튼']).click();
  await expect(reviewModal).not.toBeVisible();
  await expect(page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰'])).toHaveCount(3);
  const createdReview = page.getByTestId(TEST_ID['리뷰 목록']).getByTestId(TEST_ID['리뷰']).nth(0);
  await expect(createdReview).toContainText('asdf');
  await expect(createdReview).toContainText('과자과자고');
  await expect(createdReview).toContainText('4.0');
});

test('리뷰의 내용을 작성하여 작성 버튼을 누르면 맨 위에 리뷰가 추가된다 (이미지 미입력)', async ({ page }) => {
  test.skip(); // 이 시나리오는 보너스 스펙을 구현한 사람을 위해 테스트하지 않는다
});

const fillCreateReviewModal = async (
  page: Page,
  {
    image,
    name,
    rating,
    content,
  }: Partial<{ image: string | null; name: string | null; rating: string | null; content: string | null }>,
) => {
  const modal = page.getByTestId(TEST_ID['리뷰 작성 모달']);
  if (typeof image === 'string') await modal.getByTestId(TEST_ID['리뷰 작성 모달 이미지 인풋']).fill(image);
  if (image === null) await modal.getByTestId(TEST_ID['리뷰 작성 모달 이미지 인풋']).clear();
  if (typeof name === 'string') await modal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 인풋']).fill(name);
  if (name === null) await modal.getByTestId(TEST_ID['리뷰 작성 모달 과자이름 인풋']).clear();
  if (typeof rating === 'string') await modal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋']).fill(rating);
  if (rating === null) await modal.getByTestId(TEST_ID['리뷰 작성 모달 평점 인풋']).clear();
  if (typeof content === 'string') await modal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋']).fill(content);
  if (content === null) await modal.getByTestId(TEST_ID['리뷰 작성 모달 내용 인풋']).clear();
};
