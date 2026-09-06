*** Settings ***
Resource    ../../../pom/store/get_order_by_id/get_order_by_id_pom.resource
Resource    ../../../flow/store/place_order/place_order_flow.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Seed An Order For Lookup
    [Documentation]    Places a fresh order via the Place Order flow so this test has a guaranteed valid orderId
    ...    to look up.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Place Order - Status Code 200
    RETURN    ${response.json()['id']}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Order By Id - Status Code 200
    [Arguments]    ${order_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${order_id}' == '${EMPTY}'
        ${order_id}=    Seed An Order For Lookup
    END
    ${response}=    Call GET Get Order By Id    ${order_id}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${ORDER_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Order By Id - Status Code 400
    [Arguments]    ${order_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${order_id}' == '${EMPTY}'
        ${order_id}=    Set Variable    invalid-id
    END
    ${response}=    Call GET Get Order By Id    ${order_id}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Order By Id - Status Code 404
    [Arguments]    ${order_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${order_id}' == '${EMPTY}'
        ${order_id}=    Set Variable    999999999
    END
    ${response}=    Call GET Get Order By Id    ${order_id}
    Should Be Equal As Integers    ${response.status_code}    404

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call GET Get Order By Id
    [Documentation]    Calls the GET Get Order By Id keyword from the POM.
    [Arguments]    ${order_id}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    GET Get Order By Id    ${order_id}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Store - Get Order By Id - GET - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Get Order By Id test scenario based on the provided
    ...    HTTP status code.
    [Arguments]    ${meuOrderId}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    GET Get Order By Id - Status Code 200    ${meuOrderId}
    ...    ELSE IF    '${meuHTTP}' == '400'    GET Get Order By Id - Status Code 400    ${meuOrderId}
    ...    ELSE IF    '${meuHTTP}' == '404'    GET Get Order By Id - Status Code 404    ${meuOrderId}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Get Order By Id test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
