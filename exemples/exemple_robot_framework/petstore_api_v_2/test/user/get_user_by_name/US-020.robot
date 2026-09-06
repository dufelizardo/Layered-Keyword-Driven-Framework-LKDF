*** Settings ***
Resource    ../../../src/scenario/user/get_user_by_name/get_user_by_name_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-020
Metadata    Test Suite Description        This test suite validates the GET user by name endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    GetUserByName    PetstoreAPIv2    US-020
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-020: Validate GET Get User By Name - HTTP 200 OK
    [Documentation]    Test case to validate the GET user by name endpoint with HTTP 200 OK response.
    [Tags]    GET    GetUserByName    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - GET BY NAME - GET    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-020: Validate GET Get User By Name - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the GET user by name endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    GET    GetUserByName    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - GET BY NAME - GET    ${get_user_by_name_invalid_username_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-020: Validate GET Get User By Name - HTTP 404 NOT FOUND
    [Documentation]    Test case to validate the GET user by name endpoint with HTTP 404 NOT FOUND response.
    [Tags]    GET    GetUserByName    HTTP404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    USER - GET BY NAME - GET    ${get_user_by_name_nonexistent_username_404}    404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
