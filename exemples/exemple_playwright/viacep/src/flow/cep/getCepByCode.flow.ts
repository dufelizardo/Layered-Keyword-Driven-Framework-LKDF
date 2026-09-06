import { expect, APIRequestContext, APIResponse } from '@playwright/test';
import { getCepByCode } from '../../pom/cep/getCepByCode.pom';
import { validateObjectSchema } from '../common/schemaValidation.flow';
import { ADDRESS_SCHEMA, CEP_NOT_FOUND_SCHEMA } from '../../resource/schema/cep/cep.schema';

// "Not found" is not a distinct HTTP status on this API - a syntactically valid but unassigned CEP
// still returns 200, just with a {"erro": "true"} body instead of an address. So the dispatcher
// below routes by a scenario name (found/not_found/invalid_format) rather than by HTTP status code
// alone - and TypeScript makes that scenario a compile-time-checked union instead of a free string.
export type GetCepByCodeScenario = 'found' | 'not_found' | 'invalid_format';

async function callGetCepByCode(session: APIRequestContext, cep: string): Promise<APIResponse> {
    return getCepByCode(session, cep);
}

export async function getCepByCodeFound(
    session: APIRequestContext,
    cep: string = '01001000',
): Promise<APIResponse> {
    const response = await callGetCepByCode(session, cep);
    expect(response.status()).toBe(200);
    validateObjectSchema(await response.json(), ADDRESS_SCHEMA);

    return response;
}

export async function getCepByCodeNotFound(
    session: APIRequestContext,
    cep: string = '99999999',
): Promise<APIResponse> {
    const response = await callGetCepByCode(session, cep);
    expect(response.status()).toBe(200);
    validateObjectSchema(await response.json(), CEP_NOT_FOUND_SCHEMA);

    return response;
}

export async function getCepByCodeInvalidFormat(
    session: APIRequestContext,
    cep: string = '123',
): Promise<APIResponse> {
    const response = await callGetCepByCode(session, cep);
    expect(response.status()).toBe(400);
    // Note: the 400 response body is HTML, not JSON - do not call response.json() here.

    return response;
}

export async function getCepByCodeByScenario(
    session: APIRequestContext,
    scenario: GetCepByCodeScenario,
    cep?: string,
): Promise<APIResponse> {
    switch (scenario) {
        case 'found':
            return getCepByCodeFound(session, cep);
        case 'not_found':
            return getCepByCodeNotFound(session, cep);
        case 'invalid_format':
            return getCepByCodeInvalidFormat(session, cep);
    }
}
