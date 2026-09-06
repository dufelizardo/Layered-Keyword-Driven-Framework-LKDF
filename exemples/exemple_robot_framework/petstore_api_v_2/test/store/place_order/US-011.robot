*** Settings ***
Resource    ../../../src/scenario/store/place_order/place_order_scenario.resource
Resource    ../../../src/resource/config/driven/data_driven.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-011
Metadata    Test Suite Description        This test suite validates the POST place order endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               POST    PlaceOrder    PetstoreAPIv2    US-011
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-011: Validate POST Place Order - HTTP 200 OK
    [Documentation]    Test case to validate the POST place order endpoint with HTTP 200 OK response.
    [Tags]    POST    PlaceOrder    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    STORE - PLACE ORDER - POST    ${EMPTY}    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-011: Validate POST Place Order - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the POST place order endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    POST    PlaceOrder    HTTP400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    STORE - PLACE ORDER - POST    ${place_order_invalid_data_400}    400
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
