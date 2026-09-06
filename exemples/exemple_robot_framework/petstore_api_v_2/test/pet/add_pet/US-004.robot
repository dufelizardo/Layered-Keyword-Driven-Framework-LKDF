*** Settings ***
Resource    ../../../src/scenario/pet/add_pet/add_pet_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-004
Metadata    Test Suite Description        This test suite validates the POST add pet endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               POST    AddPet    PetstoreAPIv2    US-004
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-004: Validate POST Add Pet - HTTP 200 OK
    [Documentation]    Test case to validate the POST add pet endpoint with HTTP 200 OK response.
    [Tags]    POST    AddPet    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - ADD - POST    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-004: Validate POST Add Pet - HTTP 405 METHOD NOT ALLOWED
    [Documentation]    Test case to validate the POST add pet endpoint with HTTP 405 METHOD NOT ALLOWED response.
    [Tags]    POST    AddPet    HTTP405
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - ADD - POST    ${add_pet_invalid_data_405}    405
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
