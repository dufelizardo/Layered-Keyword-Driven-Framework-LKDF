*** Settings ***
Resource    ../../../src/scenario/pet/update_pet/update_pet_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-003
Metadata    Test Suite Description        This test suite validates the PUT update pet endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               PUT    UpdatePet    PetstoreAPIv2    US-003
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-003: Validate PUT Update Pet - HTTP 200 OK
    [Documentation]    Test case to validate the PUT update pet endpoint with HTTP 200 OK response.
    [Tags]    PUT    UpdatePet    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE - PUT    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-003: Validate PUT Update Pet - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the PUT update pet endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    PUT    UpdatePet    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE - PUT    ${update_pet_invalid_id_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-003: Validate PUT Update Pet - HTTP 404 NOT FOUND
    [Documentation]    Test case to validate the PUT update pet endpoint with HTTP 404 NOT FOUND response.
    [Tags]    PUT    UpdatePet    HTTP404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE - PUT    ${update_pet_nonexistent_id_404}    404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-004 - US-003: Validate PUT Update Pet - HTTP 405 METHOD NOT ALLOWED
    [Documentation]    Test case to validate the PUT update pet endpoint with HTTP 405 METHOD NOT ALLOWED response.
    [Tags]    PUT    UpdatePet    HTTP405
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE - PUT    ${update_pet_invalid_data_405}    405
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
