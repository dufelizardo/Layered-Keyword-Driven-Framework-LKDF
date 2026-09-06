*** Settings ***
Resource    ../../../flow/user/create_users_with_array_input/create_users_with_array_input_flow.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
USER - CREATE WITH ARRAY INPUT - POST
    [Documentation]    Test scenario for creating users with array input (POST /user/createWithArray) on the
    ...    Swagger Petstore v2 API.
    [Arguments]    ${meuLista}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    User - Create With Array Input - POST - By HTTP Status Code    ${meuLista}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
