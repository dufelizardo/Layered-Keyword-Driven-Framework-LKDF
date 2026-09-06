*** Settings ***
Resource    ../../../src/scenario/cep/search_address_by_query/search_address_by_query_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-026
Metadata    Test Suite Description        This test suite validates the GET search address by query endpoint of the ViaCEP API.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    SearchAddressByQuery    ViaCEP    US-026
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-026: Validate GET Search Address By Query - Found
    [Documentation]    Test case to validate the search address endpoint with a valid UF/city/street combination.
    [Tags]    GET    SearchAddressByQuery    Found
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    CEP - SEARCH ADDRESS - GET    ${EMPTY}    ${EMPTY}    ${EMPTY}    found
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-026: Validate GET Search Address By Query - No Results
    [Documentation]    Test case to validate the search address endpoint with a street that does not exist.
    [Tags]    GET    SearchAddressByQuery    NoResults
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    CEP - SEARCH ADDRESS - GET
    ...    ${search_address_no_results}[uf]
    ...    ${search_address_no_results}[city]
    ...    ${search_address_no_results}[street]
    ...    no_results
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-026: Validate GET Search Address By Query - Invalid Format
    [Documentation]    Test case to validate the search address endpoint with a city name shorter than 3 characters.
    [Tags]    GET    SearchAddressByQuery    InvalidFormat
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    CEP - SEARCH ADDRESS - GET
    ...    ${search_address_invalid_format}[uf]
    ...    ${search_address_invalid_format}[city]
    ...    ${search_address_invalid_format}[street]
    ...    invalid_format
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
