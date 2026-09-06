*** Settings ***
Resource    ../../../src/scenario/pet/find_by_status/find_by_status_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-006
Metadata    Test Suite Description        This test suite validates the GET find pets by status endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    FindPetsByStatus    PetstoreAPIv2    US-006
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-006: Validate GET Find Pets By Status - HTTP 200 OK
    [Documentation]    Test case to validate the GET find pets by status endpoint with HTTP 200 OK response.
    [Tags]    GET    FindPetsByStatus    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - FIND BY STATUS - GET    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-006: Validate GET Find Pets By Status - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the GET find pets by status endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    GET    FindPetsByStatus    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - FIND BY STATUS - GET    ${find_by_status_invalid_value_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
