*** Settings ***
Resource    ../../../src/scenario/user/update_user/update_user_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-021
Metadata    Test Suite Description        This test suite validates the PUT update user endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               PUT    UpdateUser    PetstoreAPIv2    US-021
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-021: Validate PUT Update User - HTTP 200 OK
    [Documentation]    Test case to validate the PUT update user endpoint with HTTP 200 OK response.
    [Tags]    PUT    UpdateUser    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - UPDATE - PUT    ${EMPTY}    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-021: Validate PUT Update User - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the PUT update user endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    PUT    UpdateUser    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - UPDATE - PUT    ${update_user_invalid_username_400}    ${EMPTY}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-021: Validate PUT Update User - HTTP 404 NOT FOUND
    [Documentation]    Test case to validate the PUT update user endpoint with HTTP 404 NOT FOUND response.
    [Tags]    PUT    UpdateUser    HTTP404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - UPDATE - PUT    ${update_user_nonexistent_username_404}    ${EMPTY}    404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
