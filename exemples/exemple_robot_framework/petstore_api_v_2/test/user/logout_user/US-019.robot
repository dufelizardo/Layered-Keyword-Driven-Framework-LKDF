*** Settings ***
Resource    ../../../src/scenario/user/logout_user/logout_user_scenario.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-019
Metadata    Test Suite Description        This test suite validates the GET logout user endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    LogoutUser    PetstoreAPIv2    US-019
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-019: Validate GET Logout User - HTTP 200 OK
    [Documentation]    Test case to validate the GET logout user endpoint with HTTP 200 OK response.
    [Tags]    GET    LogoutUser    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - LOGOUT - GET    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
