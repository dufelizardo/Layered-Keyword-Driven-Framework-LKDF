import { test } from '../fixtures';
import { cepSearchAddress } from '../../src/scenario/cep/searchAddressByQuery.scenario';
import { SEARCH_ADDRESS_NO_RESULTS, SEARCH_ADDRESS_INVALID_FORMAT } from '../../src/resource/dataDriven/cep/cep.driven';

test.describe('US-026: Search Address By Query', () => {
    test('CT-001: Found', async ({ viacepSession }) => {
        await cepSearchAddress(viacepSession, 'found');
    });

    test('CT-002: No Results', async ({ viacepSession }) => {
        const { uf, city, street } = SEARCH_ADDRESS_NO_RESULTS;
        await cepSearchAddress(viacepSession, 'no_results', uf, city, street);
    });

    test('CT-003: Invalid Format', async ({ viacepSession }) => {
        const { uf, city, street } = SEARCH_ADDRESS_INVALID_FORMAT;
        await cepSearchAddress(viacepSession, 'invalid_format', uf, city, street);
    });
});
