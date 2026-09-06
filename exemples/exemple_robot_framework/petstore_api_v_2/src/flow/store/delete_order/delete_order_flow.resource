*** Settings ***
Resource    ../../../pom/store/delete_order/delete_order_pom.resource
Resource    ../../../flow/store/place_order/place_order_flow.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Seed An Order For Deletion
    [Documentation]    Places a fresh order via the Place Order flow so this test has a guaranteed valid orderId
    ...    to delete.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Place Order - Status Code 200
    RETURN    ${response.json()['id']}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

DELETE Delete Order - Status Code 200
    [Arguments]    ${order_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${order_id}' == '${EMPTY}'
        ${order_id}=    Seed An Order For Deletion
    END
    ${response}=    Call DELETE Delete Order    ${order_id}
    Should Be Equal As Integers    ${response.status_code}    200

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

DELETE Delete Order - Status Code 400
    [Arguments]    ${order_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${order_id}' == '${EMPTY}'
        ${order_id}=    Set Variable    invalid-id
    END
    ${response}=    Call DELETE Delete Order    ${order_id}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

DELETE Delete Order - Status Code 404
    [Arguments]    ${order_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${order_id}' == '${EMPTY}'
        ${order_id}=    Set Variable    999999999
    END
    ${response}=    Call DELETE Delete Order    ${order_id}
    Should Be Equal As Integers    ${response.status_code}    404

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call DELETE Delete Order
    [Documentation]    Calls the DELETE Delete Order keyword from the POM.
    [Arguments]    ${order_id}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    DELETE Delete Order    ${order_id}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Store - Delete Order - DELETE - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Delete Order test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuOrderId}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    DELETE Delete Order - Status Code 200    ${meuOrderId}
    ...    ELSE IF    '${meuHTTP}' == '400'    DELETE Delete Order - Status Code 400    ${meuOrderId}
    ...    ELSE IF    '${meuHTTP}' == '404'    DELETE Delete Order - Status Code 404    ${meuOrderId}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Delete Order test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
