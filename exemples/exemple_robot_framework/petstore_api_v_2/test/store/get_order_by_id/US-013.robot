*** Settings ***
Resource    ../../../src/scenario/store/get_order_by_id/get_order_by_id_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-013
Metadata    Test Suite Description        This test suite validates the GET order by id endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    GetOrderById    PetstoreAPIv2    US-013
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-013: Validate GET Get Order By Id - HTTP 200 OK
    [Documentation]    Test case to validate the GET order by id endpoint with HTTP 200 OK response.
    [Tags]    GET    GetOrderById    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    STORE - GET ORDER BY ID - GET    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-013: Validate GET Get Order By Id - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the GET order by id endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    GET    GetOrderById    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    STORE - GET ORDER BY ID - GET    ${get_order_by_id_invalid_id_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-003 - US-013: Validate GET Get Order By Id - HTTP 404 NOT FOUND
    [Documentation]    Test case to validate the GET order by id endpoint with HTTP 404 NOT FOUND response.
    [Tags]    GET    GetOrderById    HTTP404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    STORE - GET ORDER BY ID - GET    ${get_order_by_id_nonexistent_id_404}    404
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
