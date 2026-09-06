*** Settings ***
Resource    ../../../src/scenario/pet/update_pet_with_form/update_pet_with_form_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-009
Metadata    Test Suite Description        This test suite validates the POST update pet with form endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               POST    UpdatePetWithForm    PetstoreAPIv2    US-009
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-009: Validate POST Update Pet With Form - HTTP 200 OK
    [Documentation]    Test case to validate the POST update pet with form endpoint with HTTP 200 OK response.
    [Tags]    POST    UpdatePetWithForm    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE WITH FORM - POST    ${EMPTY}    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-009: Validate POST Update Pet With Form - HTTP 405 METHOD NOT ALLOWED
    [Documentation]    Test case to validate the POST update pet with form endpoint with HTTP 405 METHOD NOT ALLOWED response.
    [Tags]    POST    UpdatePetWithForm    HTTP405
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE WITH FORM - POST    ${EMPTY}    ${update_pet_with_form_invalid_data_405}    405
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
