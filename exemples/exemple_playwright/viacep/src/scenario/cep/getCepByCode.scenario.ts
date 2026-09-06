import { APIRequestContext, APIResponse } from '@playwright/test';
import { getCepByCodeByScenario, GetCepByCodeScenario } from '../../flow/cep/getCepByCode.flow';

/**
 * Test scenario for looking up an address by CEP (GET /ws/{cep}/json/) on the ViaCEP API.
 * SCENARIO layer: pure pass-through, zero logic.
 */
export async function cepGetByCode(
    session: APIRequestContext,
    scenario: GetCepByCodeScenario,
    cep?: string,
): Promise<APIResponse> {
    return getCepByCodeByScenario(session, scenario, cep);
}
