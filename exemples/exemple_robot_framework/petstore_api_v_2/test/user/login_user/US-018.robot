*** Settings ***
Resource    ../../../src/scenario/user/login_user/login_user_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-018
Metadata    Test Suite Description        This test suite validates the GET login user endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    LoginUser    PetstoreAPIv2    US-018
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-018: Validate GET Login User - HTTP 200 OK
    [Documentation]    Test case to validate the GET login user endpoint with HTTP 200 OK response.
    [Tags]    GET    LoginUser    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - LOGIN - GET    ${EMPTY}    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-018: Validate GET Login User - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the GET login user endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    GET    LoginUser    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - LOGIN - GET    ${login_user_invalid_username_400}    ${login_user_invalid_password_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
