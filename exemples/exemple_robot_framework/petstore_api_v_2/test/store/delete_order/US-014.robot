*** Settings ***
Resource    ../../../src/scenario/store/delete_order/delete_order_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-014
Metadata    Test Suite Description        This test suite validates the DELETE order endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               DELETE    DeleteOrder    PetstoreAPIv2    US-014
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-014: Validate DELETE Delete Order - HTTP 200 OK
    [Documentation]    Test case to validate the DELETE order endpoint with HTTP 200 OK response.
    [Tags]    DELETE    DeleteOrder    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    STORE - DELETE ORDER - DELETE    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-014: Validate DELETE Delete Order - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the DELETE order endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    DELETE    DeleteOrder    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    STORE - DELETE ORDER - DELETE    ${delete_order_invalid_id_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-014: Validate DELETE Delete Order - HTTP 404 NOT FOUND
    [Documentation]    Test case to validate the DELETE order endpoint with HTTP 404 NOT FOUND response.
    [Tags]    DELETE    DeleteOrder    HTTP404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    STORE - DELETE ORDER - DELETE    ${delete_order_nonexistent_id_404}    404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
