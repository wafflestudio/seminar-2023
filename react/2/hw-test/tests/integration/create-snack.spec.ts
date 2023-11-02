import test, { Page, expect } from '@playwright/test';
import { TEST_ID } from './_testids';

const img_kokal =
  'https://contents.lotteon.com/itemimage/20231019072739/LM/88/01/06/28/61/90/3_/00/1/LM8801062861903_001_1.jpg/dims/optimize/dims/resizemc/400x400';
const img_kobuk =
  'https://i.namu.wiki/i/9wnvUaEa1EkDqG-M0Pbwfdf19FJQQXV_-bnlU2SYaNcG05y2wbabiIrfrGES1M4xSgDjY39RwOvLNggDd3Huuw.webp';

test('새 과자 버튼을 누르면 /snacks/new 페이지로 이동한다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 과자 버튼']).click();

  await expect(page).toHaveURL('/snacks/new');
});

test('새 과자 페이지로 이동하면 과자 내용이 비어있다', async ({ page }) => {
  await page.goto('/snacks/new');

  await expect(page.getByTestId(TEST_ID['이미지 인풋'])).toHaveValue('');
  await expect(page.getByTestId(TEST_ID['과자 이름 인풋'])).toHaveValue('');
});

test('과자 정보를 입력하여 추가 버튼을 누르면 그 과자의 페이지로 이동한다', async ({ page }) => {
  await page.goto('/snacks/new');

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kokal);
  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬깔콘 고소한맛');

  await page.getByTestId(TEST_ID['추가 버튼']).click();
  await expect(page).toHaveURL(/\/snacks\/\d+$/);

  const card = page.getByTestId(TEST_ID['과자 카드']);
  await expect(card).toBeVisible();
  await expect(card.getByTestId(TEST_ID['과자 이름'])).toContainText('꼬깔콘 고소한맛');
  await expect(card.getByTestId(TEST_ID['과자 이미지'])).toHaveAttribute('src', img_kokal);
  await expect(card.getByTestId(TEST_ID['별점'])).toContainText(/^[1-5]\.\d+$/);
});

test('새 과자에는 리뷰가 없다', async ({ page }) => {
  await page.goto('/snacks/new');

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kokal);
  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬깔콘 고소한맛');
  await page.getByTestId(TEST_ID['추가 버튼']).click();

  const reviewList = page.getByTestId(TEST_ID['리뷰 목록']);
  await expect(reviewList).toBeEmpty();
});

test('추가된 과자가 과자 목록 페이지에 있다', async ({ page }) => {
  await page.goto('/snacks/new');

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kokal);
  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬깔콘 고소한맛');

  await page.getByTestId(TEST_ID['추가 버튼']).click();
  await expect(page).toHaveURL(/\/snacks\/\d+$/);
  const snackId = getSnackId(await page.url());

  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['과자']).click();
  const card = page.getByTestId(TEST_ID['과자 카드']);
  await expect(card).toBeVisible();
  await expect(card.getByTestId(TEST_ID['과자 이름'])).toContainText('꼬깔콘 고소한맛');
  await expect(card.getByTestId(TEST_ID['과자 이름'])).toHaveAttribute('href', new RegExp(`${snackId}$`));
  await expect(card.getByTestId(TEST_ID['과자 이미지'])).toHaveAttribute('src', img_kokal);
  await expect(card.getByTestId(TEST_ID['별점'])).toContainText(/^[1-5]\.\d+$/);
});

test('과자를 여러 개 추가할 수 있다', async ({ page }) => {
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

  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['과자']).click();
  await expect(page.getByTestId(TEST_ID['과자 카드'])).toHaveCount(2);
});

test('과자 이름의 조건이 안 맞으면 오류가 난다', async ({ page }) => {
  const errorMessage = '첫글자와 끝글자가 공백이 아닌 1~20자 문자열로 써주세요';
  await page.goto('/snacks/new');

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kokal);

  await expect(page.getByTestId(TEST_ID['과자 이름 오류'])).toBeEmpty();
  await page.getByTestId(TEST_ID['추가 버튼']).click();
  await expect(page.getByTestId(TEST_ID['과자 이름 오류'])).toContainText(errorMessage);

  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['과자']).click();
  await expect(page.getByTestId(TEST_ID['과자 카드'])).toHaveCount(0);
});

test('새 과자 정보에 오류가 났어도 고치면 작성된다', async ({ page }) => {
  await page.goto('/snacks/new');

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kokal);
  await page.getByTestId(TEST_ID['추가 버튼']).click();

  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬깔콘 고소한맛');
  await page.getByTestId(TEST_ID['추가 버튼']).click();

  await expect(page).toHaveURL(/\/snacks\/\d+$/);
  const card = page.getByTestId(TEST_ID['과자 카드']);
  await expect(card).toBeVisible();
  await expect(card.getByTestId(TEST_ID['과자 이름'])).toContainText('꼬깔콘 고소한맛');
});

test('중복된 과자 이름이면 오류가 난다', async ({ page }) => {
  const errorMessage = '이미 존재하는 과자 이름입니다';
  await page.goto('/snacks/new');

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kokal);
  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬깔콘 고소한맛');
  await page.getByTestId(TEST_ID['추가 버튼']).click();

  await page.getByTestId(TEST_ID['헤더']).getByTestId(TEST_ID['리뷰']).click();
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 과자 버튼']).click();

  await page.getByTestId(TEST_ID['이미지 인풋']).fill(img_kobuk);
  await page.getByTestId(TEST_ID['과자 이름 인풋']).fill('꼬깔콘 고소한맛');
  await page.getByTestId(TEST_ID['추가 버튼']).click();

  await expect(page.getByTestId(TEST_ID['과자 이름 오류'])).toContainText(errorMessage);
});

test('취소 버튼을 누르면 이전 페이지로 이동한다', async ({ page }) => {
  await page.goto('/');
  await page.getByTestId(TEST_ID['우하단 녹색 버튼']).click();
  await page.getByTestId(TEST_ID['새 과자 버튼']).click();

  await page.getByTestId(TEST_ID['취소 버튼']).click();
  await expect(page).toHaveURL('/');
});

function getSnackId(url: string) {
  return url.match(/\/snacks\/(\d+)$/)?.[1];
}
