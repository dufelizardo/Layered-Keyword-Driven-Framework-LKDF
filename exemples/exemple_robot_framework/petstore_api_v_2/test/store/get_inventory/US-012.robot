*** Settings ***
Resource    ../../../src/scenario/store/get_inventory/get_inventory_scenario.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-012
Metadata    Test Suite Description        This test suite validates the GET store inventory endpoint of the Petstore API v2.
Metadata    Test Suite Owner              Eduardo Felizardo Candido
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    GetInventory    PetstoreAPIv2    US-012
Metadata    Test Suite Created On         2026-09-06
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       Layered Keyword Driven Framework (LKDF)
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Variables ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-012: Validate GET Get Inventory - HTTP 200 OK
    [Documentation]    Test case to validate the GET store inventory endpoint with HTTP 200 OK response.
    [Tags]    GET    GetInventory    HTTP200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    STORE - GET INVENTORY - GET    200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
