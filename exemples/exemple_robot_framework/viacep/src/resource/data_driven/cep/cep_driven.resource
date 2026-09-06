*** Comments ***
    ViaCEP data-driven dictionaries. Every variable is prefixed with its exact operation name to stay unique
    inside the shared config/driven/data_driven.resource aggregator namespace.
    The "found" scenarios use the FLOW builders' own defaults (called with ${EMPTY}) since this is a stable,
    read-only reference API with no seed/collision concerns - only the non-default scenarios need overrides here.
*** Variables ***
# get_cep_by_code (GET /ws/{cep}/json/)
${get_cep_by_code_not_found}          99999999
${get_cep_by_code_invalid_format}     123

# search_address_by_query (GET /ws/{uf}/{cidade}/{logradouro}/json/)
&{search_address_no_results}          uf=SP    city=Sao Paulo    street=RuaQueNaoExisteXyzabc
&{search_address_invalid_format}      uf=SP    city=Sa    street=Paulista
