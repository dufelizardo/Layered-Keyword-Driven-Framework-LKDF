import { defineConfig } from '@playwright/test';

// API-only suite (ViaCEP has no UI) - no browser project is configured, so `npx playwright install`
// is not required to run these tests.
export default defineConfig({
    testDir: './tests',
    fullyParallel: true,
    forbidOnly: !!process.env.CI,
    retries: 0,
    reporter: [
        ['list'],
        ['html', { outputFolder: 'results/playwright-report', open: 'never' }],
    ],
    outputDir: 'results/test-results',
    use: {
        baseURL: 'https://viacep.com.br',
    },
});
