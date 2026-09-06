*** Settings ***
Resource    ../../../pom/store/get_inventory/get_inventory_pom.resource
Resource    ../../common/schema_validation_flow.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
GET Get Inventory - Status Code 200
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    Call GET Get Inventory
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Map Of Integers    ${response.json()}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call GET Get Inventory
    [Documentation]    Calls the GET Get Inventory keyword from the POM.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    GET Get Inventory

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Store - Get Inventory - GET - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Get Inventory test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    GET Get Inventory - Status Code 200
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Get Inventory test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
