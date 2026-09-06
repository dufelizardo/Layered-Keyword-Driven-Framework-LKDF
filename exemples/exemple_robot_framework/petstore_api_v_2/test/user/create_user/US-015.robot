*** Settings ***
Resource    ../../../src/scenario/user/create_user/create_user_scenario.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-015
Metadata    Test Suite Description        This test suite validates the POST create user endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               POST    CreateUser    PetstoreAPIv2    US-015
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-015: Validate POST Create User - HTTP 200 OK
    [Documentation]    Test case to validate the POST create user endpoint with HTTP 200 OK response.
    [Tags]    POST    CreateUser    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - CREATE - POST    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
