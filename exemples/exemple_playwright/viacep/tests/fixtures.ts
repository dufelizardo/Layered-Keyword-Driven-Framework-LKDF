import { test as base, APIRequestContext } from '@playwright/test';
import { getViaCepSession } from '../src/pom/common/viacepSession';

// TEST-layer plumbing: creates/disposes the shared ViaCEP session (POM layer) around every test,
// the idiomatic Playwright equivalent of calling "Get ViaCEP Session" at the start of each keyword
// in the Robot Framework version of this example.
type ViaCepFixtures = {
    viacepSession: APIRequestContext;
};

export const test = base.extend<ViaCepFixtures>({
    viacepSession: async ({}, use) => {
        const session = await getViaCepSession();
        await use(session);
        await session.dispose();
    },
});

export { expect } from '@playwright/test';
