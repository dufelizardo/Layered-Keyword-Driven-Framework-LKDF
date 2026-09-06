*** Settings ***
Resource    ../../src/scenario/put/put_petstore_scenario.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-002
Metadata    Test Suite Description        This test suite validates the PUT update pet endpoint of the Petstore API.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               PUT    UpdatePet    PetstoreAPI    US-002
Metadata    Test Suite Created On         2026-09-05
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-002: Validate PUT Update Pet - HTTP 200 OK
    [Documentation]    Test case to validate the PUT update pet endpoint with HTTP 200 OK response.
    [Tags]    PUT    UpdatePet    HTTP200   
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE - PUT    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════ 
CT-002 - US-002: Validate PUT Update Pet - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the PUT update pet endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    PUT    UpdatePet    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE - PUT    ${EMPTY}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
CT-003 - US-002: Validate PUT Update Pet - HTTP 404 NOT FOUND
    [Documentation]    Test case to validate the PUT update pet endpoint with HTTP 404 NOT FOUND response.
    [Tags]    PUT    UpdatePet    HTTP404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE - PUT    ${EMPTY}   404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
CT-004 - US-002: Validate PUT Update Pet - HTTP 405 METHOD NOT ALLOWED
    [Documentation]    Test case to validate the PUT update pet endpoint with HTTP 405 METHOD NOT ALLOWED response.
    [Tags]    PUT    UpdatePet    HTTP405    
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE - PUT    ${EMPTY}    405
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-005 - US-002: Validate PUT Update Pet - HTTP 500 INTERNAL SERVER ERROR
    [Documentation]    Test case to validate the PUT update pet endpoint with HTTP 500 INTERNAL SERVER ERROR response.
    [Tags]    PUT    UpdatePet    HTTP500   
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    PET - UPDATE - PUT    ${EMPTY}    500
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════