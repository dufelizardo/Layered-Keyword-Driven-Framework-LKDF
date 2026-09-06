import { APIRequestContext, APIResponse } from '@playwright/test';

/**
 * Sends a GET request to search addresses by UF/city/street and returns the raw response.
 * POM layer: no assertions, no business logic.
 */
export async function searchAddressByQuery(
    session: APIRequestContext,
    uf: string,
    city: string,
    street: string,
): Promise<APIResponse> {
    const cityEncoded = encodeURIComponent(city);
    const streetEncoded = encodeURIComponent(street);
    return session.get(`/ws/${uf}/${cityEncoded}/${streetEncoded}/json/`);
}
