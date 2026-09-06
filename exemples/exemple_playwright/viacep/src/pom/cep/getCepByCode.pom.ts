import { APIRequestContext, APIResponse } from '@playwright/test';

/**
 * Sends a GET request to look up an address by CEP and returns the raw response.
 * POM layer: no assertions, no business logic.
 */
export async function getCepByCode(session: APIRequestContext, cep: string): Promise<APIResponse> {
    return session.get(`/ws/${cep}/json/`);
}
