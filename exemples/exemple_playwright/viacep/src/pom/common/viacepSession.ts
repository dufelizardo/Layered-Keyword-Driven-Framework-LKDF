import { request, APIRequestContext } from '@playwright/test';

const HOST_URL = 'https://viacep.com.br';

/**
 * Creates a fresh RequestContext (session) for the ViaCEP API. POM layer: zero business logic.
 */
export async function getViaCepSession(): Promise<APIRequestContext> {
    return request.newContext({ baseURL: HOST_URL });
}
