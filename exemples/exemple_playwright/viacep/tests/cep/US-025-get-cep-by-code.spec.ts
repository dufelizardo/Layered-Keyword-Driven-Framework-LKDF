import { test } from '../fixtures';
import { cepGetByCode } from '../../src/scenario/cep/getCepByCode.scenario';
import { GET_CEP_BY_CODE_NOT_FOUND, GET_CEP_BY_CODE_INVALID_FORMAT } from '../../src/resource/dataDriven/cep/cep.driven';

test.describe('US-025: Get Cep By Code', () => {
    test('CT-001: Found', async ({ viacepSession }) => {
        await cepGetByCode(viacepSession, 'found');
    });

    test('CT-002: Not Found', async ({ viacepSession }) => {
        await cepGetByCode(viacepSession, 'not_found', GET_CEP_BY_CODE_NOT_FOUND);
    });

    test('CT-003: Invalid Format', async ({ viacepSession }) => {
        await cepGetByCode(viacepSession, 'invalid_format', GET_CEP_BY_CODE_INVALID_FORMAT);
    });
});
