import { expect, APIRequestContext, APIResponse } from '@playwright/test';
import { searchAddressByQuery } from '../../pom/cep/searchAddressByQuery.pom';
import { validateArraySchema } from '../common/schemaValidation.flow';
import { ADDRESS_SCHEMA } from '../../resource/schema/cep/cep.schema';

// Like getCepByCode, "no results" is not a distinct HTTP status here - an invalid UF or a street
// with no matches still returns 200, just with an empty array. The dispatcher below routes by a
// scenario name (found/no_results/invalid_format) rather than by HTTP status code alone.
export type SearchAddressScenario = 'found' | 'no_results' | 'invalid_format';

async function callSearchAddressByQuery(
    session: APIRequestContext,
    uf: string,
    city: string,
    street: string,
): Promise<APIResponse> {
    return searchAddressByQuery(session, uf, city, street);
}

export async function searchAddressFound(
    session: APIRequestContext,
    uf: string = 'SP',
    city: string = 'São Paulo',
    street: string = 'Paulista',
): Promise<APIResponse> {
    const response = await callSearchAddressByQuery(session, uf, city, street);
    expect(response.status()).toBe(200);
    validateArraySchema(await response.json(), ADDRESS_SCHEMA);

    return response;
}

export async function searchAddressNoResults(
    session: APIRequestContext,
    uf: string = 'SP',
    city: string = 'São Paulo',
    street: string = 'RuaQueNaoExisteXyzabc',
): Promise<APIResponse> {
    const response = await callSearchAddressByQuery(session, uf, city, street);
    expect(response.status()).toBe(200);
    const body = await response.json();
    validateArraySchema(body, ADDRESS_SCHEMA);
    expect(body, `Expected an empty array for a no-results scenario, got: ${JSON.stringify(body)}`).toEqual([]);

    return response;
}

export async function searchAddressInvalidFormat(
    session: APIRequestContext,
    uf: string = 'SP',
    city: string = 'Sa',
    street: string = 'Paulista',
): Promise<APIResponse> {
    const response = await callSearchAddressByQuery(session, uf, city, street);
    expect(response.status()).toBe(400);
    // Note: the 400 response body is HTML, not JSON - do not call response.json() here.

    return response;
}

export async function searchAddressByScenario(
    session: APIRequestContext,
    scenario: SearchAddressScenario,
    uf?: string,
    city?: string,
    street?: string,
): Promise<APIResponse> {
    switch (scenario) {
        case 'found':
            return searchAddressFound(session, uf, city, street);
        case 'no_results':
            return searchAddressNoResults(session, uf, city, street);
        case 'invalid_format':
            return searchAddressInvalidFormat(session, uf, city, street);
    }
}
