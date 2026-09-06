*** Settings ***
Resource    ../../../src/scenario/pet/find_by_tags/find_by_tags_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-007
Metadata    Test Suite Description        This test suite validates the GET find pets by tags endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    FindPetsByTags    PetstoreAPIv2    US-007
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-007: Validate GET Find Pets By Tags - HTTP 200 OK
    [Documentation]    Test case to validate the GET find pets by tags endpoint with HTTP 200 OK response.
    [Tags]    GET    FindPetsByTags    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - FIND BY TAGS - GET    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-007: Validate GET Find Pets By Tags - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the GET find pets by tags endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    GET    FindPetsByTags    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - FIND BY TAGS - GET    ${find_by_tags_invalid_value_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
