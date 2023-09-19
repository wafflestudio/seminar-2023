import { defineConfig, devices } from '@playwright/test';

const CI = true;
const PORT = 5173;

/**
 * See https://playwright.dev/docs/test-configuration.
 */
export default defineConfig({
  testDir: './tests/integration',
  fullyParallel: true,
  forbidOnly: CI,
  retries: CI ? 2 : 0,
  workers: CI ? 4 : undefined,
  reporter: CI ? 'dot' : 'html',
  use: {
    video: 'retain-on-failure',
    baseURL: `http://localhost:${PORT}`,
    trace: 'retain-on-failure',
    permissions: ['clipboard-read'],
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
});
