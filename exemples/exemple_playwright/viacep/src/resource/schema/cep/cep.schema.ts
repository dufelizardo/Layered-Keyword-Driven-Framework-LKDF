import { FieldSchema } from '../../../flow/common/schemaValidation.flow';

// Every field returned by ViaCEP is a string - including the "numeric-looking" ones (ddd, ibge,
// siafi, gia) - confirmed directly against the live API, not just the docs.
export const ADDRESS_SCHEMA: FieldSchema = {
    required: ['cep', 'logradouro', 'bairro', 'localidade', 'uf'],
    types: {
        cep: 'string',
        logradouro: 'string',
        complemento: 'string',
        unidade: 'string',
        bairro: 'string',
        localidade: 'string',
        uf: 'string',
        estado: 'string',
        regiao: 'string',
        ibge: 'string',
        gia: 'string',
        ddd: 'string',
        siafi: 'string',
    },
};

export const CEP_NOT_FOUND_SCHEMA: FieldSchema = {
    required: ['erro'],
    types: { erro: 'string' },
};
