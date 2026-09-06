*** Settings ***
Resource    ../../../src/scenario/pet/delete_pet/delete_pet_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-010
Metadata    Test Suite Description        This test suite validates the DELETE pet endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               DELETE    DeletePet    PetstoreAPIv2    US-010
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-010: Validate DELETE Delete Pet - HTTP 200 OK
    [Documentation]    Test case to validate the DELETE pet endpoint with HTTP 200 OK response.
    [Tags]    DELETE    DeletePet    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - DELETE - DELETE    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-010: Validate DELETE Delete Pet - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the DELETE pet endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    DELETE    DeletePet    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - DELETE - DELETE    ${delete_pet_invalid_id_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-010: Validate DELETE Delete Pet - HTTP 404 NOT FOUND
    [Documentation]    Test case to validate the DELETE pet endpoint with HTTP 404 NOT FOUND response.
    [Tags]    DELETE    DeletePet    HTTP404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - DELETE - DELETE    ${delete_pet_nonexistent_id_404}    404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
