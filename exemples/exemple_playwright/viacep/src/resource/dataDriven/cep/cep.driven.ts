// ViaCEP data-driven constants for negative/edge-case scenarios. "Found" scenarios use the FLOW
// functions' own defaults (see src/flow/cep/*.flow.ts) since this is a stable, read-only reference
// API with no seed/collision concerns - only the non-default scenarios need values here.

export const GET_CEP_BY_CODE_NOT_FOUND = '99999999';
export const GET_CEP_BY_CODE_INVALID_FORMAT = '123';

export const SEARCH_ADDRESS_NO_RESULTS = {
    uf: 'SP',
    city: 'Sao Paulo',
    street: 'RuaQueNaoExisteXyzabc',
};

export const SEARCH_ADDRESS_INVALID_FORMAT = {
    uf: 'SP',
    city: 'Sa',
    street: 'Paulista',
};
