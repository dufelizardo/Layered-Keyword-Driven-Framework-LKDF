*** Settings ***
Resource    ../../../src/scenario/user/create_users_with_list_input/create_users_with_list_input_scenario.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-017
Metadata    Test Suite Description        This test suite validates the POST create users with list input endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               POST    CreateUsersWithListInput    PetstoreAPIv2    US-017
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-017: Validate POST Create Users With List Input - HTTP 200 OK
    [Documentation]    Test case to validate the POST create users with list input endpoint with HTTP 200 OK response.
    [Tags]    POST    CreateUsersWithListInput    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - CREATE WITH LIST INPUT - POST    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
