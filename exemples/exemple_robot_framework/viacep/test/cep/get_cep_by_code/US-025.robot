*** Settings ***
Resource    ../../../src/scenario/cep/get_cep_by_code/get_cep_by_code_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-025
Metadata    Test Suite Description        This test suite validates the GET cep by code endpoint of the ViaCEP API.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    GetCepByCode    ViaCEP    US-025
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-025: Validate GET Get Cep By Code - Found
    [Documentation]    Test case to validate the GET cep by code endpoint with a valid, existing CEP.
    [Tags]    GET    GetCepByCode    Found
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    CEP - GET BY CODE - GET    ${EMPTY}    found
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-025: Validate GET Get Cep By Code - Not Found
    [Documentation]    Test case to validate the GET cep by code endpoint with a valid but unassigned CEP.
    [Tags]    GET    GetCepByCode    NotFound
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    CEP - GET BY CODE - GET    ${get_cep_by_code_not_found}    not_found
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-025: Validate GET Get Cep By Code - Invalid Format
    [Documentation]    Test case to validate the GET cep by code endpoint with a malformed CEP.
    [Tags]    GET    GetCepByCode    InvalidFormat
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    CEP - GET BY CODE - GET    ${get_cep_by_code_invalid_format}    invalid_format
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
