*** Settings ***
Resource    ../../../src/scenario/user/delete_user/delete_user_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-022
Metadata    Test Suite Description        This test suite validates the DELETE user endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               DELETE    DeleteUser    PetstoreAPIv2    US-022
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-022: Validate DELETE Delete User - HTTP 200 OK
    [Documentation]    Test case to validate the DELETE user endpoint with HTTP 200 OK response.
    [Tags]    DELETE    DeleteUser    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - DELETE - DELETE    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-022: Validate DELETE Delete User - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the DELETE user endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    DELETE    DeleteUser    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - DELETE - DELETE    ${delete_user_invalid_username_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-022: Validate DELETE Delete User - HTTP 404 NOT FOUND
    [Documentation]    Test case to validate the DELETE user endpoint with HTTP 404 NOT FOUND response.
    [Tags]    DELETE    DeleteUser    HTTP404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - DELETE - DELETE    ${delete_user_nonexistent_username_404}    404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
