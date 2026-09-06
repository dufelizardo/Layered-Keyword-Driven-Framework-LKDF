import { APIRequestContext, APIResponse } from '@playwright/test';
import { searchAddressByScenario, SearchAddressScenario } from '../../flow/cep/searchAddressByQuery.flow';

/**
 * Test scenario for searching addresses by UF/city/street
 * (GET /ws/{uf}/{cidade}/{logradouro}/json/) on the ViaCEP API.
 * SCENARIO layer: pure pass-through, zero logic.
 */
export async function cepSearchAddress(
    session: APIRequestContext,
    scenario: SearchAddressScenario,
    uf?: string,
    city?: string,
    street?: string,
): Promise<APIResponse> {
    return searchAddressByScenario(session, scenario, uf, city, street);
}
