*** Settings ***
Resource    ../../../pom/store/place_order/place_order_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Build Place Order Payload
    [Documentation]    Builds a flexible payload for placing an order, based on the Swagger Petstore v2 Order schema.
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${base}=    Create Dictionary
    ...    id=0
    ...    petId=0
    ...    quantity=1
    ...    shipDate=2026-09-06T00:00:00.000Z
    ...    status=placed
    ...    complete=${FALSE}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    $custom_fields == ''
        ${payload}=    Set Variable    ${base}
    ELSE
        ${payload}=    Evaluate    dict(${base}, **${custom_fields})
    END
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    RETURN    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

POST Place Order - Status Code 200
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Place Order Payload    ${custom_fields}
    ${response}=    Call POST Place Order    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${ORDER_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

POST Place Order - Status Code 400
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Place Order Payload    ${custom_fields}
    ${response}=    Call POST Place Order    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call POST Place Order
    [Documentation]    Calls the POST Place Order keyword from the POM.
    [Arguments]    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Place Order    ${payload}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Store - Place Order - POST - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Place Order test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuOrder}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    POST Place Order - Status Code 200    ${meuOrder}
    ...    ELSE IF    '${meuHTTP}' == '400'    POST Place Order - Status Code 400    ${meuOrder}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Place Order test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
